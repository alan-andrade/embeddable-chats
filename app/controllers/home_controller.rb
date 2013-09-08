class HomeController < ApplicationController
  before_filter :requires_authentication, except: :index
  before_filter :requires_no_authentication, only: :index

  def dashboard
    @user = current_user
  end
end
