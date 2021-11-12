class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    return login_fail unless
        user.try(:authenticate, params[:session][:password])

    if user.activated
      log_in user
      params[:session][:remember_me] == Settings.check ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash[:warning] = t "flash.check_email_acti"
      redirect_to root_url
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
