# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?
  def signin
    new_token = User.generate_token
    @user.update_attribute(:token_digest, User.encrypt_token(new_token))
    session[:user_id] = @user.id
    cookies.permanent.signed[:user_id] = @user.id
    cookies.permanent[:token] = new_token
    current_user
  end

  def logged_in?
    current_user != nil
  end

  def current_user
    session_user_id = session[:user_id]
    cookies_user_id = cookies[:user_id]
    if !session_user_id.nil?
      @current_user ||= User.find_by(id: session[:user_id])
    elsif !cookies_user_id.nil?
      user = User.find_by(id: cookies[:user_id])
      if user && BCrypt::Password.new(user.token_digest).is_password?(cookies.permanent[:token])
        session[:user_id] = cookies[:user_id]
        @current_user ||= User.find_by(id: cookies[:user_id])
      end
    end
  end

  attr_writer :current_user

  def signout
    session.delete(:user_id)
    cookies.delete(:user_id)
    cookies.delete(:token)
    current_user&.forget
    @current_user = nil
  end

  def user_logged
    redirect_to login_path unless logged_in?
  end

  private

  def check_login
    redirect_to posts_path if logged_in?
  end
end
