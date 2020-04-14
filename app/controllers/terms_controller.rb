class TermsController < ApplicationController
  include RestoreSearch
  before_action :check_super_user_role
  before_action :load_vocabulary

  def index
    params[:q] ||= {}
    params[:q][:s] ||= 'name asc'
    @search = @vocabulary.terms.ransack(params[:q])
    @terms = @search.result.page(params[:page] || 1)
  end

  def show
    @term = @vocabulary.terms.find params[:id]
  end

  def peeps
    @term = @vocabulary.terms.find params[:term_id]
    @records = @term.records_for(params[:year].to_i).page(params[:page] || 1).per(10)
    render layout: false
  end

  def new
    @term = @vocabulary.terms.build
  end

  def create
    @term = @vocabulary.terms.new resource_params
    if @term.save
      flash[:notice] = "Added the new term."
      redirect_to action: :index
    else
      flash[:errors] = "Sorry couldn't do it."
      render action: :new
    end
  end

  def edit
    @term = @vocabulary.terms.find params[:id]
  end

  def update
    @term = @vocabulary.terms.find params[:id]
    if @term.update resource_params
      flash[:notice] = "Updated the term."
      redirect_to action: :index
    else
      if @term.is_duplicate?
        @term.merge!
        flash[:notice] = "Merged the term!"
        redirect_to action: :index
      else
        flash[:errors] = "Sorry couldn't do it."
        render action: :edit
      end
    end
  end

  def destroy
    @term = @vocabulary.terms.find(params[:id])
    if @term.destroy
      flash[:notice] = "Deleted the term."
      redirect_to action: :index
    else
      flash[:errors] = "Sorry couldn't do it."
      redirect_back fallback_location: { action: :index }
    end
  end

  private

  def load_vocabulary
    @vocabulary = Vocabulary.find params[:vocabulary_id]
  end

  def resource_params
    params.require(:term).permit(:name)
  end
end