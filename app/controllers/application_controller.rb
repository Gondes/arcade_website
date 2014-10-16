class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if current_account.user_id.nil?
      new_user_path
    else
      user_path(current_account.user_id)
    end
  end

  def after_sign_out_path_for(resource)
    "/"
  end
end
