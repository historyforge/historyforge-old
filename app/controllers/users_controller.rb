class UsersController < ApplicationController
  layout 'application'

  before_action :authenticate_user!, only: [:show, :edit, :update]

  before_action :check_super_user_role, only: [:index, :new, :create, :destroy, :enable, :disable, :stats, :disable_and_reset, :force_confirm]

  rescue_from ActiveRecord::RecordNotFound, with: :bad_record

  # helper :sort
  # include SortHelper

  def stats
    # sort_init "total_count"
    # sort_update

    @html_title = "Users Stats"

    the_sql = "select user_id, username, COUNT(user_id) as total_count,
      COUNT(case when auditable_type='Gcp' then 1 end) as gcp_count,

      COUNT(case when auditable_type='Map' or auditable_type='Mapscan' then 1 end) as map_count,

      COUNT(case when action='update' and auditable_type='Gcp' then 1 end) as gcp_update_count,

      COUNT(case when action='create' and auditable_type='Gcp' then 1 end) as gcp_create_count,

      COUNT(case when action='destroy' and auditable_type='Gcp' then 1 end) as gcp_destroy_count

      from audits group by user_id, username ORDER BY username ASC"


    @users_activity = Kaminari.paginate_array(Audited::Audit.find_by_sql(the_sql)).page(params[:page] || 1).per(30)
  end


  def index
    @html_title = "Users"
    # sort_init 'email'
    # sort_update
    @query = params[:query]
    @field = %w(login email provider).detect{|f| f == (params[:field])}
    if @query && @query.strip.length > 0 && @field
      conditions = ["#{@field}  ~* ?", '(:punct:|^|)'+@query+'([^A-z]|$)']
    else
      conditions = nil
    end
    @users = User.where(conditions).order('login asc').page(params[:page] || 1).per(30)

  end

  def show
    @user = User.find(params[:id]) || current_user
    @html_title = "Showing User "+ @user.login.capitalize
    @mymaps = @user.maps.order("updated_at DESC").page(params[:page] || 1).per(8)
    @current_user_maps = current_user.maps
    respond_to do | format |
      format.html {}
      format.js {}
      format.json {render json: {stat: "ok",items: @user.to_a}.to_json(only: [:login, :created_at, :stat, :items, :enabled ])  }
    end

  end

  def new
    @html_title = 'Add New User'
    @user = User.new
    authorize! :create, @user
  end

  def create
    @html_title = 'Add New User'
    @user = User.new user_params
    authorize! :create, @user
    if @user.save
      flash[:notice] = 'User created'
      redirect_to user_path(@user)
    else
      flash[:errors] = 'Could not create user'
      render action: :new
    end
  end

  def edit
    @html_title = "Edit User Settings"
    @user = params[:id] ? User.find(params[:id]) : current_user
    authorize! :update, @user
  end

  def update
    @user = current_user
    @user = params[:id] ? User.find(params[:id]) : current_user
    authorize! :update, @user
    if @user.update_attributes(user_params)
      flash[:notice] = "User updated"
      redirect_to user_path(@user)
    else
      @html_title = "Edit User Settings"
      render action: 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    unless @user.has_role?("administrator") ||  @user.has_role?("super user")
      if @user.destroy
        flash[:notice] = "User successfully deleted"
      else
        flash[:error] = "User could not be deleted"
      end
    else
      flash[:error] = "Admins cannot be destroyed"
    end
    redirect_to action: 'index'
  rescue PG::ForeignKeyViolation
    flash[:error] = "Cannot delete error because they have added records, such as building and census records, that we would prefer not to delete or orphan. We suggest you disable the user instead."
    redirect_to action: 'index'
  end

  def disable_and_reset
    @user = User.find(params[:id])
    if @user.provider?
      flash[:error] = "Sorry, users from other providers are not able to be reset"
      return redirect_to action: 'show'
    end
    unless @user.has_role?("administrator") ||  @user.has_role?("super user")
      generated_password = Devise.friendly_token.first(8)
      @user.password=generated_password
      @user.password_confirmation=generated_password

      if @user.save
        UserMailer.disabled_change_password(@user).deliver_now
        @user.send_reset_password_instructions
        flash[:notice] = "User changed and an email sent with password reset link"
      else
        flash[:error] = "Sorry, there was a problem changingin this user"
      end

    else
      flash[:error] = "Admins cannot be disabled and reset, sorry"
    end

    redirect_to action: 'show'
  end

  def disable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to action: 'index'
  end

  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user."
    end
    redirect_to action: 'index'
  end

  def bad_record
    respond_to do | format |
      format.html do
        flash[:notice] = "User not found"
        redirect_to root_path
      end
      format.json {render json: {stat: "not found", items: []}.to_json, status: 404}
    end
  end

  def mask
    @user = User.find(params[:id])
    authorize! :mask, @user
    session[:mask] = current_user.id
    sign_in @user
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:login, :email, :password, :password_confirmation)
  end

end
