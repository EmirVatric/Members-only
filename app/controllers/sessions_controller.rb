class SessionsController < ApplicationController
  def new
    current_user
  end

  def create
    @user = User.find_by_email(params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      signin
      redirect_to login_path
    else
      redirect_to login_path
    end
  end
  def destroy
    signout
    redirect_to login_path
  end
end
