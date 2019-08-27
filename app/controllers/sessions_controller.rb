# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :check_login, only: %i[new create]
  def new
    current_user
  end

  def create
    @user = User.find_by_email(params[:session][:email])
    if @user&.authenticate(params[:session][:password])
      signin
      redirect_to posts_path
    else
      redirect_to login_path
    end
  end

  def destroy
    signout
    redirect_to login_path
  end
end
