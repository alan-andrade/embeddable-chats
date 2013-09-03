class SessionsController < ApplicationController
  def create
    auth =
      Authorization.find_from_auth_hash(auth_hash) ||
      Authorization.create_from_auth_hash(auth_hash)

    current_user = auth.user
    render text: "Welcome, #{current_user.email}"
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
