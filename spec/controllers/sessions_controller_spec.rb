require 'spec_helper'

describe SessionsController do
  it 'creates an authenticated user' do
    @request.env['omniauth.auth'] =
      OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: 1234,
        info: OmniAuth::AuthHash::InfoHash.new(email: 'test@facebook.com'))

    get :create, provider: 'facebook'

    Authorization.count.should == 1
    User.count.should == 1
  end
end
