class LayersController < ApplicationController
  layout 'layerdetail', :only => [:show,  :edit, :export, :metadata]
  before_filter :authenticate_user! , :except => [:wms, :wms2, :show_kml, :show, :index, :metadata, :maps, :thumb, :tile, :trace, :id]
  before_filter :check_administrator_role, :only => [:publish, :toggle_visibility, :merge, :trace, :id]

  before_filter :find_layer, :only => [:show, :export, :metadata, :toggle_visibility, :update_year, :publish, :remove_map, :merge, :maps, :thumb, :trace, :id]
  before_filter :check_if_layer_is_editable, :only => [:edit, :update, :remove_map, :update_year, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, :with => :bad_record

  def thumb
    redirect_to @layer.thumb
  end


  def index
    # sort_init('created_at', {:default_order => "desc"})
    # session[@sort_name] = nil  #remove the session sort as we have percent
    # sort_update
    @query = params[:query]
    @field = %w(name description).detect{|f| f== (params[:field])}
    @field = "name" if @field.nil?
    if @query && @query != "null" #null will be set by pagless js if theres no query
      conditions =   ["#{@field}  ~* ?", '(:punct:|^|)'+@query+'([^A-z]|$)']
    else
      conditions = nil
    end
    if params[:sort_key] == "percent"
      select = "*, round(rectified_maps_count::float / maps_count::float * 100) as percent"
      conditions.nil? ? conditions = ["maps_count > 0"] : conditions.add_condition('maps_count > 0')
    else
      select = "*"
    end

    if params[:sort_order] && params[:sort_order] == "desc"
      sort_nulls = " NULLS LAST"
    else
      sort_nulls = " NULLS FIRST"
    end

    @per_page = params[:per_page] || 20
    paginate_params = {
      :page => params[:page],
      :per_page => @per_page
    }

    # order_options =  sort_clause  + sort_nulls

    map = params[:map_id]
    if !map.nil?
      @map = Map.find(map)
      layer_ids = @map.layers.map(&:id)
      @layers = Layer.where(id: layer_ids).select('*, round(rectified_maps_count::float / maps_count::float * 100) as percent').where(conditions).order(order_options)
      @html_title = "Map Layer List for Map #{@map.id}"
      @page = "for_map"
    else
      @layers = Layer.select(select).where(conditions)
      @html_title = "Browse Map Layers"
    end

    if !user_signed_in? || request.format.json?
      @layers = @layers.where(is_visible: true)
    end

    @layers = @layers.paginate(paginate_params)

    if request.xhr?
      # for pageless :
      # #render :partial => 'layer', :collection => @layers
      render :action => 'index.rjs'
    else
      respond_to do |format|
        format.html {render :layout => "application"}

        format.xml { render :xml => @layers.to_xml(:root => "layers", :except => [:uuid, :parent_uuid, :description]) {|xml|
            xml.tag!'total-entries', @layers.total_entries
            xml.tag!'per-page', @layers.per_page
            xml.tag!'current-page',@layers.current_page}
        }
        format.json {render :json => {:stat => "ok", :items => @layers.to_a}.to_json(:except => [:uuid, :parent_uuid, :description]), :callback => params[:callback] }
      end
    end
  end


  #method returns json or xml representation of a layers maps
  def maps
    paginate_params = {
      :page => params[:page],
      :per_page => 50
    }

    show_warped = params[:show_warped]
    unless show_warped == "0"
      lmaps = @layer.maps.warped.order(:map_type).paginate(paginate_params)
    else
      lmaps = @layer.maps.order(:map_type).paginate(paginate_params)
    end
    respond_to do |format|
      #format.json {render :json =>lmaps.to_json(:stat => "ok",:except => [:content_type, :size, :bbox_geom, :uuid, :parent_uuid, :filename, :parent_id,  :map, :thumbnail])}
      format.json {render :json =>{:stat => "ok",
          :current_page => lmaps.current_page,
          :per_page => lmaps.per_page,
          :total_entries => lmaps.total_entries,
          :total_pages => lmaps.total_pages,
          :items => lmaps.to_a}.to_json(:except => [:content_type, :size, :bbox_geom, :uuid, :parent_uuid, :filename, :parent_id,  :map, :thumbnail]), :callback => params[:callback] }

      format.xml {render :xml => lmaps.to_xml(:root => "maps",:except => [:content_type, :size, :bbox_geom, :uuid, :parent_uuid, :filename, :parent_id,  :map, :thumbnail])  {|xml|
          xml.tag!'total-entries', lmaps.total_entries
          xml.tag!'per-page', lmaps.per_page
          xml.tag!'current-page',lmaps.current_page} }
    end
  end

  def show
    @current_tab = "show"
    @selected_tab = 0
    @disabled_tabs =  []
    unless @layer.rectified_maps_count > 0 #i.e. if the layer has no maps, then dont let people  export
      @disabled_tabs = ["export"]
    end

    if  user_signed_in? and (current_user.own_this_layer?(params[:id]) or current_user.has_role?("editor"))
      @maps = @layer.maps.order(:map_type).paginate(:page => params[:page], :per_page => 30)
    else
      @disabled_tabs += ["edit"]
      @maps = @layer.maps.are_public.order(:map_type).paginate(:page => params[:page], :per_page => 30)
    end
    @html_title = "Map Layer "+ @layer.id.to_s + " " + @layer.name.to_s

    if request.xhr?
      unless params[:page]
        @xhr_flag = "xhr"
        render :action => "show", :layout => "layer_tab_container"
      else
        render :action =>  "show_maps.rjs"
      end
    else
      respond_to do |format|
        format.html {render :layout => "layerdetail"}# show.html.erb
        #format.json {render :json => @layer.to_json(:except => [:uuid, :parent_uuid, :description])}
        format.json {render :json => {:stat => "ok", :items => @layer}.to_json(:except => [:uuid, :parent_uuid, :description]), :callback => params[:callback] }
        format.xml {render :xml => @layer.to_xml(:except => [:uuid, :parent_uuid, :description])}
        format.kml {render :action => "show_kml", :layout => false}
      end
    end
  end


  def new
    #assume that the user is logged in
    @html_title = "Make new map layer -"
    @layer = Layer.new
    @maps = current_user.maps
    respond_to do |format|
      format.html {render :layout => "application"}# show.html.erb
    end
  end

  def create
    @layer = Layer.new(layer_params)
    #@maps = current_user.maps.warped
    @layer.user = current_user

    #@layer.maps = Map.find(params[:map_ids]) if params[:map_ids]
    if params[:map_ids]
      selected_maps = Map.find(params[:map_ids])
      selected_maps.each {|map| @layer.maps << map}
    end

    if @layer.save
      @layer.update_layer
      @layer.update_counts
      flash[:notice] = "Map layer was successfully created."
      redirect_to layer_url(@layer)
    else
      redirect_to new_layer_url
    end
  end

  def edit
    @layer = Layer.find(params[:id])
    @selected_tab = 1
    @current_tab = "edit"
    @html_title = "Editing map layer #{@layer.id} on"
    if (!current_user.own_this_layer?(params[:id]) and current_user.has_role?("editor"))
      @maps = @layer.user.maps
    else
      @maps = current_user.maps  #current_user.maps.warped
    end

    if request.xhr?
      @xhr_flag = "xhr"
      render :action => "edit", :layout => "layer_tab_container"
    else
      respond_to do |format|
        format.html {render :layout => "layerdetail"}# show.html.erb
      end
    end
  end

  def update
    @layer = Layer.find(params[:id])
    @maps = current_user.maps
    @layer.maps = Map.find(params[:map_ids]) if params[:map_ids]
    if @layer.update_attributes(layer_params)
      @layer.update_layer
      @layer.update_counts
      flash.now[:notice] = "Map layer was successfully updated."
      #redirect_to layer_url(@layer)
    else
    flash.now[:error] = "The map layer was not able to be updated"

    end
    if request.xhr?
      @xhr_flag = "xhr"
      render :action => "edit", :layout => "layer_tab_container"
    else
      respond_to do |format|
        format.html { render :action => "edit",:layout => "layerdetail" }
      end
    end
  end

  def delete
    @layer = Layer.find(params[:id])
    respond_to do |format|
      format.html {render :layout => "application"}
    end
  end

  def destroy
    @layer = Layer.find(params[:id])
    authorize! :destroy, @layer

    if @layer.destroy
      flash[:notice] = "Map layer deleted!"
    else
      flash[:notice] = "Map layer wasn't deleted"
    end
    respond_to do |format|
      format.html { redirect_to(layers_url) }
      format.xml  { head :ok }
    end
  end

  def export
    @current_tab = "export"
    @selected_tab = 3

    @html_title = "Export Map Layer "+ @layer.id.to_s
    if request.xhr?
      @xhr_flag = "xhr"
      render :layout => "layer_tab_container"
    else
      respond_to do |format|
        format.html {render :layout => "layerdetail"}
      end
    end
  end

  def metadata
    @current_tab = "metadata"
    @selected_tab = 4
    #@layer_properties = @layer.layer_properties
    choose_layout_if_ajax
  end


  #ajax method
  def toggle_visibility
    @layer.is_visible = !@layer.is_visible
    @layer.save
    @layer.update_layer
    if @layer.is_visible
      update_text = "(Visible)"
    else
      update_text = "(Not Visible)"
    end
    render :json => {:message => update_text}
  end

  def update_year
    @layer.update_attributes(params[:layer])
    render :json => {:message => "Depicts : " + @layer.depicts_year.to_s }
  end

  #merge this layer with another one
  #moves all child object to new parent
  def merge
    if request.get?
      #just show form
      render :layout => 'application'
    elsif request.put?
      @dest_layer = Layer.find(params[:dest_id])

      @layer.merge(@dest_layer.id)
      render :text  => "Map layer has been merged into new layer - all maps copied across! (functionality disabled at the moment)"
    end
  end


  def remove_map
    @map = Map.find(params[:map_id])

    @layer.remove_map(@map.id)
    render :text =>  "Dummy text - Map removed from this map layer "
  end

  def publish
    if @layer.rectified_percent < 100
      render :text => "Map layer has less than 100% of its maps rectified"
      #redirect_to :action => 'index'
    else
      @layer.publish
      render :text => "Map layer will be published (this functionality is disabled at the moment)"
    end
  end


  def trace
    redirect_to layer_path unless @layer.is_visible? && @layer.rectified_maps_count > 0
    @overlay = @layer
    render "maps/trace", :layout => "application"
  end

  def id
    redirect_to layer_path unless @layer.is_visible? && @layer.rectified_maps_count > 0
    @overlay = @layer
    render "maps/id", :layout => false
  end

  # called by id JS oauth
  def idland
    render "maps/idland", :layout => false
  end


  private

  def check_if_layer_is_editable
    @layer = Layer.find(params[:id])
    authorize! :update, @layer
  end

  #little helper method
  def snippet(thought, wordcount)
    thought.split[0..(wordcount-1)].join(" ") +(thought.split.size > wordcount ? "..." : "")
  end

  def find_layer
    @layer = Layer.find(params[:id])
  end

  def choose_layout_if_ajax
    if request.xhr?
      @xhr_flag = "xhr"
      render :layout => "layer_tab_container"
    end
  end

  def bad_record
    #logger.error("not found #{params[:id]}")
    respond_to do | format |
      format.html do
        flash[:notice] = "Map layer not found"
        redirect_to :action => :index
      end
      format.json {render :json => {:stat => "not found", :items =>[]}.to_json, :status => 404}
    end
  end

  def store_location
    case request.parameters[:action]
    when "metadata"
      anchor = "Metadata_tab"
    when "export"
      anchor = "Export_tab"
    else
      anchor = ""
    end
    if request.parameters[:action] &&  request.parameters[:id]
      session[:return_to] = layer_path(:id => request.parameters[:id], :anchor => anchor)
    else
      session[:return_to] = request.request_uri
    end
  end

  def layer_params
    params.require(:layer).permit(:name, :description, :source_uri, :depicts_year)
  end

end
