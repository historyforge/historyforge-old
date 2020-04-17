class PeopleController < ApplicationController
  def show
    @person = Person.find params[:id]
    authorize! :read, @person
  end
end