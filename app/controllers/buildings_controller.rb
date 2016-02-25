class BuildingsController < ApplicationController

  def index
    authorize! :read, Building
    @per_page = params[:per_page] || 10
    paginate_params = {
      :page => params[:page],
      :per_page => @per_page
    }
    @buildings = Building.includes(:architects, :building_type).paginate(paginate_params)
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
    params.require(:building).permit(:name, :year_earliest, :year_latest, :description, :address, :city, :state, :postal_code, :building_type_id, :lat, :lon, :architects_list)
  end

end
