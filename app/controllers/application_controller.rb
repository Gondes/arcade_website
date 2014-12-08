class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if current_user.id.nil?
      new_user_path
    else
      user_path(current_user.id)
    end
  end

  def after_sign_out_path_for(resource)
    "/"
  end

  # Checks if current_user is the same as user with some_id
  def valid_user(some_id)
    (user_exists and some_id == current_user.id)# or current_user.try(:admin?)
  end

  def user_exists
    user_signed_in? and !(current_user.id.nil?)
  end

  def user_admin?
    user_signed_in? and current_user.admin
  end

  def user_master_admin?
    user_signed_in? and current_user.admin
  end

end
