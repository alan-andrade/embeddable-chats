class SessionsController < ApplicationController
  def create
    auth =
      Authorization.find_from_auth_hash(auth_hash) ||
      Authorization.create_from_auth_hash(auth_hash)

    authenticate auth.user
    redirect_to dashboard_path
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  private

  def authenticate user
    session[:user_id] = user.id
    @current_user = user
  end
end
