module AdvancedRestoreSearch
  extend ActiveSupport::Concern

  included do
    before_action :restore_search, only: %i[index], unless: :json_request?
  end

  private

  def json_request?
    request.format.json?
  end

  def restore_search
    s_key = "s_#{controller_name}"
    if params[:reset]
      session.delete s_key
      redirect_to action: params[:action]
    else
      if params[:s] || params[:f] || params[:fs]
        session[s_key] = {}
        session[s_key][:s] = params[:s].dup
        session[s_key][:fs] = params[:fs].dup
        session[s_key][:f] = params[:f].dup
      elsif session.key?(s_key)
        redirect_to session[s_key].merge(action: params[:action])
      end
    end
  end
end
