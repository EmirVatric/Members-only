class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user,:logged_in?
  def signin 
    new_token=User.generate_token
    @user.update_attribute(:token_digest,User.encrypt_token(new_token))
    session[:user_id] = @user.id
    cookies.permanent.signed[:user_id] = @user.id
    cookies.permanent[:token]=new_token
    current_user
  end
  def logged_in?
    current_user != nil
  end
  def current_user
    if user_id = session[:user_id]
      @current_user ||=User.find_by(id:session[:user_id])
    elsif user_id = cookies[:user_id]
      user=User.find_by(id:cookies[:user_id])
      if user && BCrypt::Password.new(user.token_digest).is_password?(cookies.permanent[:token])
        session[:user_id]=cookies[:user_id]
        @current_user ||=User.find_by(id:cookies[:user_id])
      end
    else
      nil
    end
  end
  def current_user= user
    @current_user = user
  end
  def signout
    session.delete(:user_id)
    cookies.delete(:user_id)
    cookies.delete(:token)
    current_user.forget if not current_user.nil? 
    current_user= nil
  end

  def user_logged
    if !logged_in?
      redirect_to login_path
    end
  end
end
