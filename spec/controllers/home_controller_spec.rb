require 'spec_helper'

describe HomeController do
  it 'should redirect to dashboard whenever is signed in' do
    @controller.stub signed_in?: true

    get :index
    expect(response).to redirect_to dashboard_path
  end

  it 'should redirect to root for login' do
    get :dashboard
    expect(response).to redirect_to root_path
  end
end
