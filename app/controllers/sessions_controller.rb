class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      check_activated user
    else
      danger_flash
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.users_controller.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
