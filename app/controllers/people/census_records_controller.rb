class People::CensusRecordsController < ApplicationController
  include AdvancedRestoreSearch

  respond_to :json, only: :index
  respond_to :csv, only: :index
  respond_to :html

  def index
    @page_title = page_title
    load_census_records
    render_census_records
  end

  def new
    authorize! :create, resource_class
    @record = resource_class.new
    @record.set_defaults
    if params[:attributes]
      params[:attributes].each do |key, value|
        @record.public_send "#{key}=", value
      end
    end
  end

  def building_autocomplete
    record = resource_class.new
    record.street_house_number = params[:house]
    record.street_name = params[:street]
    record.city = params[:city]
    buildings = record.buildings_on_street
    buildings = buildings.map {|building| { id: building.id, name: building.name } }
    render json: buildings.to_json
  end

  def autocomplete
    attribute = params[:attribute]
    term = params[:term]
    vocab = Vocabulary.controlled_attribute_for year, attribute
    results = if vocab
                vocab.ransack(name_start: term).result.distinct.limit(15).pluck('name')
              else
                resource_class.ransack(:"#{attribute}_start" => term).result.distinct.limit(15).pluck(attribute)
              end
    render json: results.map(&:strip).uniq
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
    if @record.update(resource_params)
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
      flash[:errors] = 'Unable to delete census record.'
      redirect_back fallback_location: { action: :index }
    end
  end

  def save_as
    @record = resource_class.find params[:id]
    authorize! :create, resource_class
    after_saved
  end

  def reviewed
    @record = resource_class.find params[:id]
    authorize! :review, @record
    @record.reviewed_by ||= current_user
    @record.reviewed_at ||= Time.now
    @record.save
    flash[:notice] = 'The census record is marked as reviewed and available for public view.'
    redirect_back fallback_location: { action: :index }
  end

  private

  def page_title
    raise 'Need to implement page title.'
  end

  def resource_class
    raise 'resource_class needs a constant name!'
  end

  def resource_params
    params[:census_record].each do |key2, value|
      params[:census_record][key2] = nil if value == 'on' || value == 'nil'
    end
    params.require(:census_record).permit!
  end

  def after_saved
    if params[:then].present?
      attrs = []
      attrs +=  case params[:then]
                when 'enumeration'
                  %w{page_number page_side county city ward enum_dist}
                when 'page'
                  %w{page_number page_side county city ward enum_dist}
                when 'dwelling'
                  %w{page_number page_side county city ward enum_dist dwelling_number street_house_number street_prefix street_suffix street_name building_id}
                when 'family'
                  %w{page_number page_side county city ward enum_dist dwelling_number street_house_number street_prefix street_suffix street_name family_id building_id}
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
    @search = census_record_search_class.generate params: params, user: current_user, entity_class: resource_class, paged: request.format.html?, per: 100
    if current_user
      maybe_add_scope :unreviewed
      maybe_add_scope :unhoused
    end
  end

  def render_census_records
    if request.format.html?
      render action: :index
    else
      @records = @search.to_a
      if params[:from]
        render json: @search.row_data(@records)
      elsif request.format.csv?
        filename = "historyforge.csv"
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
        respond_with @records, each_serializer: CensusRecordSerializer
      end
    end
  end

  def census_record_search_class; end

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
