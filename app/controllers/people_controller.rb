class PeopleController < ApplicationController
  def index
    load_people
    render_people
  end

  def show
    @person = Person.find params[:id]
    authorize! :read, @person
  end

  def new_resource_path
    new_person_path
  end

  helper_method :new_resource_path

  private

  def load_people
    authorize! :read, Person
    @search = PersonSearch.generate params: params, user: current_user, paged: request.format.html?, per: 100
    if current_user
      maybe_add_scope :unreviewed
    end
  end

  def render_people
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
        respond_with @records, each_serializer: PersonSerializer
      end
    end
  end

end