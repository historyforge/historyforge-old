class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit

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


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: %i[login description email password password_confirmation]
    devise_parameter_sanitizer.permit :account_update, keys: %i[login description email password password_confirmation current_password]
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

  def maybe_add_scope(param)
    if current_user && params[param] && params[param] == '1'
        @search.public_send "#{param}!"
    end
  end
end
