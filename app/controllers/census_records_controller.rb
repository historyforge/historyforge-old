class CensusRecordsController < ApplicationController

  # TODO: accommodate census records other than 1910

  respond_to :json, only: :index
  respond_to :html

  def index
    authorize! :read, CensusRecord
    unless params[:q].andand[:s]
      params[:q] ||= {}
      params[:q][:s] = 'last_name asc'
    end
    @search = Census1910Record.ransack(params[:q])
    @records = @search.result
    unless request.format.json?
      @per_page = params[:per_page] || 25
      paginate_params = {
        :page => params[:page],
        :per_page => @per_page
      }
      @records = @records.paginate(paginate_params)
    end
    respond_with @records
  end

  def new
    authorize! :create, CensusRecord
    @record = Census1910Record.new
  end

  def create
    @record = Census1910Record.new resource_params
    authorize! :create, @record
    if @record.save
      flash[:notice] = 'Census Record created.'
      redirect_to action: :show
    else
      flash[:errors] = 'Census Record not saved.'
      render action: :new
    end
  end

  def show
    @record = Census1910Record.includes(:architects, :building_type).find params[:id]
    authorize! :read, @record
  end

  def edit
    @record = Census1910Record.find params[:id]
    # @record.photos.build
    authorize! :update, @record
  end

  def update
    @record = Census1910Record.find params[:id]
    authorize! :update, @record
    if @record.update_attributes(resource_params)
      flash[:notice] = 'Census Record updated.'
      redirect_to action: :show
    else
      flash[:errors] = 'Census Record not saved.'
      render action: :edit
    end
  end

  def destroy
    @record = Census1910Record.find params[:id]
    authorize! :destroy, @record
    if @record.destroy
      flash[:notice] = 'Census Record deleted.'
      redirect_to action: :index
    else
      flash[:errors] = 'Unable to delete building.'
      redirect_to :back
    end
  end

  private

  def resource_params
    params.require(:census_record).permit!
  end
end
