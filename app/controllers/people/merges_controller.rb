module People
  class MergesController < ApplicationController
    def new
      authorize! :merge, Person
      @target = Person.find params[:person_id]
      @source = Person.find params[:merge_id]
      @check = MergeEligibilityCheck.new(@source, @target)
      @check.perform
    end

    def create
      authorize! :merge, Person
      @target = Person.find params[:person_id]
      @source = Person.find params[:merge_id]
      @check = MergeEligibilityCheck.new(@source, @target)
      @check.perform
      if @check.okay?
        MergePeople.new(@source, @target).perform
        flash[:notice] = "The merge operation has been performed."
        redirect_to @target
      else
        flash[:errors] = "You can't merge this people."
        redirect_back fallback_location: { action: :new }
      end
    end
  end
end