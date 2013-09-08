class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find_by_id session[:user_id]
  end

  def signed_in?
    current_user.present?
  end

  protected

  def requires_authentication
    signed_in? or redirect_to(root_path)
  end

  def requires_no_authentication
    redirect_to dashboard_path if signed_in?
  end
end
