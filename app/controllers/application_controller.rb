class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit

  if Rails.env.production?
    rescue_from ActiveRecord::RecordNotFound,
                ActionController::RoutingError,
                ActionController::MethodNotAllowed, with: :render_404
  end

  before_action :check_cms_for_page
  layout :cms_choose_layout

  rescue_from CanCan::AccessDenied, with: :permission_denied

  def check_super_user_role
    check_role('super user')
  end

  def check_administrator_role
    check_role("administrator")
  end

  def check_developer_role
    check_role("developer")
  end

  def check_cms_for_page
    Rails.logger.info "Looking for #{params[:controller]}##{params[:action]} template."
    a = params[:action]
    a = 'new' if a == 'create'
    a = 'edit' if a == 'update'
    @page = Cms::Page.where(controller: self.class.name, action: a).first
  end

  def cms_choose_layout
    @page.present? ? 'cms' : 'application'
  end

  def render_404
    @page = Cms::Page.where(controller: 'pages', action: '404').first_or_initialize
    if @page.new_record?
      @page.title = '404 Page Not Found'
      @page.url_path = '/404_error'
      @page.template = "The page was not found :(\r\n\r\n{{content}}"
      @page.save!
    end
    render('cms/pages/page_404', status: 404, layout: 'cms')
    true
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: %i[login description email password password_confirmation]
    devise_parameter_sanitizer.permit :account_update, keys: %i[login description email password password_confirmation current_password]
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[login password password_confirmation])
    devise_parameter_sanitizer.permit(:invite, keys: %i[login email])
  end

  def check_role(role)
    unless user_signed_in? && @current_user.has_role?(role)
      permission_denied
    end
  end

  def permission_denied
    flash[:errors] = "Sorry you do not have permission to do that."
    redirect_to root_path
  end

  private

  def after_invite_path_for(_user)
    users_path
  end

end
