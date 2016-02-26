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
      redirect_to action: :show
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
    authorize! :update, @building
  end

  def update
    @building = Building.find params[:id]
    authorize! :update, @building
    if @building.update_attributes(building_params)
      flash[:notice] = 'Building updated.'
      redirect_to action: :show
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

  private

  def building_params
    params.require(:building).permit(:name, :description, :annotations, :stories,
                                     :year_earliest, :year_latest, :year_latest_circa, :year_earliest_circa,
                                     :address, :city, :state, :postal_code,
                                     :address_house_number, :address_street_prefix,
                                     :address_street_name, :address_street_suffix,
                                     :building_type_id, :lining_type_id, :frame_type_id,
                                     :lat, :lon, :architects_list)
  end

end
