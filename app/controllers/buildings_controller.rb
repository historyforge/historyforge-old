class BuildingsController < ApplicationController

  include RestoreSearch

  respond_to :json, only: %i[index show]
  respond_to :csv, only: :index
  respond_to :html

  def index
    # MemoryProfiler.start
    @page_title = 'Buildings'
    load_buildings
    respond_with @buildings, each_serializer: BuildingListingSerializer
    # report = MemoryProfiler.stop
    # report.pretty_print to_file: Rails.root.join('log', 'memory.log')
  end

  def unpeopled
    @page_title = "Buildings - Unpeopled"
    params[:unpeopled] = 1
    load_buildings
    render action: :index
  end

  def unreviewed
    @page_title = "Buildings - Unreviewed"
    authorize! :review, Building
    params[:unreviewed] = 1
    load_buildings
    render action: :index
  end

  def uninvestigated
    @page_title = "Buildings - Need to Investigate"
    authorize! :review, Building
    params[:uninvestigated] = 1
    load_buildings
    render action: :index
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
    @building = Building.includes(:architects, :building_type).find params[:id]
    authorize! :read, @building
    if request.format.html?
      @neighbors = @building.neighbors.map { |building| BuildingListingSerializer.new(building) }
      @layer = Layer.where(depicts_year: 1910).first
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

    if @building.update_attributes(building_params)
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
    @photo = Photo.find params[:id]
    image = ::MiniMagick::Image.open @photo.photo.path

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

    image.auto_orient
    image.resize width

    path = File.join Rails.root, 'public', 'photos', params[:id], params[:style]
    FileUtils.mkdir_p path
    filename = "#{path}/#{params[:device]}.jpg"
    image.write filename

    self.content_type = 'image/jpeg'
    self.status = 200
    self.response_body = File.open(filename).read

  rescue ::MiniMagick::Error, ::MiniMagick::Invalid => e
    default = I18n.translate(:"errors.messages.mini_magick_processing_error", :e => e, :locale => :en)
    message = I18n.translate(:"errors.messages.mini_magick_processing_error", :e => e, :default => default)
    raise CarrierWave::ProcessingError, message
  end

  private

  def building_params
    params.require(:building).permit(:name, :description, :annotations, :stories, :block_number,
                                     :year_earliest, :year_latest, :year_latest_circa, :year_earliest_circa,
                                     :address, :city, :state, :postal_code,
                                     :address_house_number, :address_street_prefix,
                                     :address_street_name, :address_street_suffix,
                                     :building_type_id, :lining_type_id, :frame_type_id,
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
    if request.format.json?
      @search.expanded = true
      # @search.paged = true #params[:s].blank?
      # @search.per = params[:s] ? 500 : 50
      @buildings = @search.as_json
    else
      @buildings = @search.to_a.map {|building| BuildingPresenter.new(building, current_user) }
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
