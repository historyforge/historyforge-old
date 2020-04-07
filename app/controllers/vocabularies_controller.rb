class VocabulariesController < ApplicationController
  before_action :check_super_user_role

  def index
    @vocabularies = Vocabulary.order(:name)
  end
end