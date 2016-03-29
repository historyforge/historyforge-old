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
    if params[:attributes]
      params[:attributes].each do |key, value|
        @record.public_send "#{key}=", value
      end
    end
  end

  def building_autocomplete
    record = CensusRecord.new
    record.street_name = params[:street]
    record.city = params[:city]
    buildings = record.buildings_on_street
    buildings = buildings.map {|building| { id: building.id, name: building.name } }
    render json: buildings
  end

  def create
    @record = Census1910Record.new resource_params
    authorize! :create, @record
    if @record.save
      flash[:notice] = 'Census Record created.'
      after_saved
    else
      flash[:errors] = 'Census Record not saved.'
      render action: :new
    end
  end

  def show
    @record = Census1910Record.find params[:id]
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
      after_saved
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

  def after_saved
    if params[:then].present?
      attrs = []
      attrs += case params[:then]
      when 'enumeration'
        %w{page_number county city ward enum_dist}
      when 'page'
        %w{page_number county city ward enum_dist}
      when 'dwelling'
        %w{page_number county city ward enum_dist dwelling_number street_house_number street_prefix street_suffix street_name}
      when 'family'
        %w{page_number county city ward enum_dist dwelling_number street_house_number street_prefix street_suffix street_name family_id}
      end
      attributes = attrs.inject({}) {|hash, item|
        hash[item] = @record.public_send(item)
        hash
      }
      redirect_to action: :new, attributes: attributes
    else
      redirect_to @record
    end
  end

end
