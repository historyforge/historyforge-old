class People::CensusRecordsController < ApplicationController

  include RestoreSearch

  respond_to :json, only: :index
  respond_to :html

  def index
    @page_title = page_title
    load_census_records
    respond_with @records
  end

  def unreviewed
    @page_title = "#{page_title} - Unreviewed"
    params[:s] ||= {}
    params[:s][:reviewed_at_null] = 1
    load_census_records
    render action: :index
  end

  def unhoused
    @page_title = "#{page_title} - Unhoused"
    params[:s] ||= {}
    params[:s][:building_id_null] = 1
    load_census_records
    render action: :index
  end

  def new
    authorize! :create, resource_class
    @record = resource_class.new
    if params[:attributes]
      params[:attributes].each do |key, value|
        @record.public_send "#{key}=", value
      end
    end
  end

  def building_autocomplete
    record = resource_class.new
    record.street_name = params[:street]
    record.city = params[:city]
    buildings = record.buildings_on_street
    buildings = buildings.map {|building| { id: building.id, name: building.name } }
    render json: buildings.to_json
  end

  def create
    @record = resource_class.new resource_params
    authorize! :create, @record
    @record.created_by = current_user
    if can?(:review, @record)
      @record.reviewed_by = current_user
      @record.reviewed_at = Time.now
    end
    if @record.save
      flash[:notice] = 'Census Record created.'
      after_saved
    else
      flash[:errors] = 'Census Record not saved.'
      render action: :new
    end
  end

  def show
    @record = resource_class.find params[:id]
    authorize! :read, @record
  end

  def edit
    @record = resource_class.find params[:id]
    # @record.photos.build
    authorize! :update, @record
    # @record.building = @record.matching_building if @record.building_id.blank? && @record.street_house_number && @record.street_name
  end

  def update
    @record = resource_class.find params[:id]
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
    @record = resource_class.find params[:id]
    authorize! :destroy, @record
    if @record.destroy
      flash[:notice] = 'Census Record deleted.'
      redirect_to action: :index
    else
      flash[:errors] = 'Unable to delete building.'
      redirect_to :back
    end
  end

  def save_as
    @record = resource_class.find params[:id]
    authorize! :create, @record
    after_saved
  end

  def reviewed
    @record = resource_class.find params[:id]
    authorize! :review, @record
    @record.reviewed_by ||= current_user
    @record.reviewed_at ||= Time.now
    @record.save
    flash[:notice] = 'The census record is marked as reviewed and available for public view.'
    redirect_to :back
  end

  private

  def page_title
    raise 'Need to implement page title.'
  end

  def resource_class
    raise 'resource_class needs a constant name!'
  end

  def resource_params
    params.require(resource_class.model_name.param_key).permit!
  end

  def after_saved
    if params[:then].present?
      attrs = []
      attrs += case params[:then]
      when 'enumeration'
        %w{page_no page_side county city ward enum_dist}
      when 'page'
        %w{page_no page_side county city ward enum_dist}
      when 'dwelling'
        %w{page_no page_side county city ward enum_dist dwelling_number street_house_number street_prefix street_suffix street_name}
      when 'family'
        %w{page_no page_side county city ward enum_dist dwelling_number street_house_number street_prefix street_suffix street_name family_id}
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

  def load_census_records
    authorize! :read, resource_class
    @search = CensusRecordSearch.generate params: params, user: current_user, entity_class: resource_class, paged: request.format.json?
    @records = @search.to_a
  end

  helper_method :resource_path,
                :edit_resource_path,
                :new_resource_path,
                :save_as_resource_path,
                :reviewed_resource_path,
                :collection_path,
                :unhoused_collection_path,
                :unreviewed_collection_path,
                :resource_class


end
