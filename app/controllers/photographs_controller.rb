class PhotographsController < ApplicationController
  def new
    @photograph = Photograph.new
    authorize! :create, @photograph
    @photograph.physical_type = PhysicalType.still_image
  end

  def create
    @photograph = Photograph.new resource_params
    authorize! :create, @photograph
    @photograph.created_by = current_user
    if @photograph.save
      flash[:notice] = 'The photograph has been uploaded and saved.'
      redirect_to @photograph
    else
      flash[:errors] = 'Sorry we could not save the photograph. Please correct the errors and try again.'
      render action: :new
    end
  end

  def show
    @photograph = Photograph.find params[:id]
    authorize! :read, @photograph
  end

  def edit
    @photograph = Photograph.find params[:id]
    authorize! :update, @photograph
  end

  def update
    @photograph = Photograph.find params[:id]
    authorize! :update, @photograph
    if @photograph.update resource_params
      flash[:notice] = 'The photograph has been updated.'
      redirect_to @photograph
    else
      flash[:errors] = 'Sorry we could not save the photograph. Please correct the errors and try again.'
      render action: :edit
    end
  end

  def destroy
    @photograph = Photograph.find params[:id]
    authorize! :destroy, @photograph
    if @photograph.destroy
      flash[:notice] = 'The photograph has been deleted.'
      redirect_to action: :index
    else
      flash[:errors] = 'Sorry we could not delete the photograph.'
      render action: :show
    end
  end

  private

  def resource_params
    params
        .require(:photograph)
        .permit :file, :title, :description,
                :creator, :subject, { building_ids: [], person_ids: [] },
                :latitude, :longitude,
                :date_text, :date_start, :date_end, :date_type,
                :physical_type_id, :physical_format_id,
                :physical_description, :location, :identifier,
                :notes, :rights_statement_id,
                :date_year, :date_month, :date_day,
                :date_year_end,
                :date_month_end,
                :date_day_end

  end
end