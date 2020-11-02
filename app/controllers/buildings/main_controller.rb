class Buildings::MainController < ApplicationController
  include AdvancedRestoreSearch

  respond_to :json, only: %i[index show]
  respond_to :csv, only: :index
  respond_to :html

  skip_before_action :verify_authenticity_token, only: :autocomplete

  def index
    @page_title = 'Buildings'
    load_buildings
    render_buildings
  end

  def autocomplete
    @buildings = Building.ransack(street_address_cont: params[:term]).result.limit(5).by_street_address
    render json: @buildings.map { |building| {
        id: building.id,
        name: building.name,
        address: building.full_street_address
    }}
  end

  def new
    authorize! :create, Building
    @building = Building.new
  end

  def create
    @building = Building.new building_params
    authorize! :create, @building
    @building.created_by = current_user
    if @building.save
      flash[:notice] = 'Building created.'
      redirect_to @building
    else
      flash[:errors] = 'Building not saved.'
      render action: :new
    end
  end

  def show
    @building = Building.includes(:architects, :building_types).find params[:id]
    authorize! :read, @building
    @building.with_filtered_residents params[:people], params[:peopleParams]
    if request.format.html?
      @neighbors = @building.neighbors.map { |building| BuildingListingSerializer.new(building) }
      @layer = MapOverlay.where(year_depicted: 1910).first
    elsif request.format.json?
      serializer = BuildingSerializer.new(@building) #, { params: { condensed: params.key?(:condensed) } })
      render json: serializer
    end
  end

  def edit
    @building = Building.find params[:id]
    @building.photos.build
    authorize! :update, @building
  end

  def update
    @building = Building.find params[:id]
    authorize! :update, @building

    if params[:Review] && can?(:review, @building) && !@building.reviewed?
      @building.reviewed_by = current_user
      @building.reviewed_at = Time.now
    end

    if @building.update(building_params)
      flash[:notice] = 'Building updated.'
      if request.format.json?
        render json: BuildingSerializer.new(@building)
      else
        redirect_to action: :show
      end
    else
      flash[:errors] = 'Building not saved.'
      render action: :edit
    end
  end

  def destroy
    @building = Building.find params[:id]
    authorize! :destroy, @building
    if @building.destroy
      flash[:notice] = 'Building deleted.'
      redirect_to action: :index
    else
      flash[:errors] = 'Unable to delete building.'
      redirect_to :back
    end
  end

  def review
    @building = Building.find params[:id]
    authorize! :review, @building
    @building.reviewed_by = current_user
    @building.reviewed_at = Time.now
    @building.investigate = false
    if @building.save
      flash[:notice] = 'Building reviewed.'
      redirect_to @building
    else
      flash[:errors] = 'Building not reviewed.'
      render action: :new
    end
  end

  def photo
    @photo = Photograph.find params[:id]

    # from style, how wide should it be? as % of 1278px
    width = case params[:device]
      when 'tablet'  then 1024
      when 'phone'   then 740
      else 1278
    end

    if params[:style] != 'full'
      case params[:style]
      when 'half'
        width = (width.to_f * 0.50).ceil
      when 'third'
        width = (width.to_f * 0.33).ceil
      when 'quarter'
        width = (width.to_f * 0.25).ceil
      else
        width = (width.to_f * (params[:style].to_f / 100.to_f)).ceil
      end
    end

    redirect_to @photo.file.variant(resize: width)
  end


  def new_resource_path
    new_building_path
  end
  helper_method :new_resource_path

  private

  def building_params
    params.require(:building).permit(:name, :description, :annotations, :stories, :block_number,
                                     :year_earliest, :year_latest, :year_latest_circa, :year_earliest_circa,
                                     :address, :city, :state, :postal_code,
                                     :address_house_number, :address_street_prefix,
                                     :address_street_name, :address_street_suffix,
                                     { :building_type_ids => [] }, :lining_type_id, :frame_type_id,
                                     :lat, :lon, :architects_list,
                                     :investigate, :investigate_reason, :notes,
                                     { photos_attributes: [:_destroy, :id, :photo, :year_taken, :caption] })
  end

  def load_buildings
    authorize! :read, Building
    massage_params
    @search = BuildingSearch.generate params: params,
                                      user: current_user,
                                      paged: request.format.html?,
                                      per: 50
  end

  def render_buildings
    if request.format.html?
      render action: :index
    elsif request.format.csv?
      filename = "historyforge-buildings.csv"
      headers["X-Accel-Buffering"] = "no"
      headers["Cache-Control"] = "no-cache"
      headers["Content-Type"] = "text/csv; charset=utf-8"
      headers["Content-Disposition"] =
          %(attachment; filename="#{filename}")
      headers["Last-Modified"] = Time.zone.now.ctime.to_s
      self.response_body = Enumerator.new do |output|
        @search.to_csv(output)
      end
    else
      if request.format.json? && !params[:from]
        @search.expanded = true
        @buildings = @search.as_json
      end

      if params[:from]
        @buildings = @search.to_a.map {|building| BuildingPresenter.new(building, current_user) }
        render json: @search.row_data(@buildings)
      else
        respond_with @buildings, each_serializer: BuildingListingSerializer
      end
    end
  end

  def massage_params
    unless params[:q]
      params[:q] = {}
      params.each_pair do |key, value|
        params[:q][key] = value unless %w{controller action page format q}.include?(key)
      end
    end
    if params[:q][:s].blank?
      params[:q][:s] = 'name asc'
    end
  end
end
