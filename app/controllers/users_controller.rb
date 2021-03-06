class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_and_check_user, only: [:show, :edit, :update, :destroy]

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "flash.please_check_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "flash.profile_updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    if @user&.destroy
      flash[:success] = t "flash.user_deleted"
    else
      flash[:danger] = t "flash.delete_fail"
    end
    redirect_to users_url
  end

  private

  def user_params
    params
      .require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash.please_login"
    redirect_to login_url
  end

  def correct_user
    find_and_check_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def find_and_check_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:warning] = t "flash.user_not_found"
    redirect_to new_user_path
  end
end
