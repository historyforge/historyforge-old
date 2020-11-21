class TermsController < ApplicationController
  include RestoreSearch
  before_action :check_super_user_role
  before_action :load_vocabulary

  def index
    params[:q] ||= {}
    params[:q][:s] ||= 'name asc'
    @search = @vocabulary.terms.ransack(params[:q])

    respond_to do |format|
      format.csv do
        @terms = @search.result
        require 'csv'
        headers['Content-Disposition'] = "attachment; filename=\"#{@vocabulary.name}.csv\""
        headers['Content-Type'] = "text/csv"
      end
      format.html do
        @terms = @search.result.page(params[:page] || 1)
      end
    end
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

  def import
    @file = params[:file].path
    found = 0
    added = 0
    require 'csv'
    CSV.foreach(@file, headers: false) do |row|
      name = row[0]
      term = @vocabulary.terms.find_or_initialize_by(name: name)
      if term.new_record?
        term.save
        added += 1
      else
        found += 1
      end
    end
    flash[:notice] = "Added #{added} terms to #{@vocabulary.name}. Found #{found} already existing."
  rescue
    flash[:errors] = "An error got in the way. Check that your file is a CSV with a single column containing the terms you wish to import."
  ensure
    redirect_to action: :index
  end

  private

  def load_vocabulary
    @vocabulary = Vocabulary.find params[:vocabulary_id]
  end

  def resource_params
    params.require(:term).permit(:name)
  end
end