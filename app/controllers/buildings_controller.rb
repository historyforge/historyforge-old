class BuildingsController < ApplicationController

  respond_to :json, only: :index
  respond_to :html

  def index
    authorize! :read, Building
    unless params[:q].andand[:s]
      params[:q] ||= {}
      params[:q][:s] = 'name asc'
    end
    @search = Building.includes(:architects, :building_type).ransack(params[:q])
    @buildings = @search.result
    unless request.format.json?
      @per_page = params[:per_page] || 25
      paginate_params = {
        :page => params[:page],
        :per_page => @per_page
      }
      @buildings = @buildings.paginate(paginate_params)
    end
    respond_with @buildings
  end

  def new
    authorize! :create, Building
    @building = Building.new
  end

  def create
    @building = Building.new building_params
    authorize! :create, @building
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
  end

  def edit
    @building = Building.find params[:id]
    @building.photos.build
    authorize! :update, @building
  end

  def update
    @building = Building.find params[:id]
    authorize! :update, @building
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
        width = (width.to_f * params[:style].to_f).ceil
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
    params.require(:building).permit(:name, :description, :annotations, :stories,
                                     :year_earliest, :year_latest, :year_latest_circa, :year_earliest_circa,
                                     :address, :city, :state, :postal_code,
                                     :address_house_number, :address_street_prefix,
                                     :address_street_name, :address_street_suffix,
                                     :building_type_id, :lining_type_id, :frame_type_id,
                                     :lat, :lon, :architects_list,
                                     { photos_attributes: [:_destroy, :id, :photo, :year_taken, :caption] })
  end

end
