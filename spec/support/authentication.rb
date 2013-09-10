def login user
  OmniAuth.config.mock_auth[:facebook] =
      OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: 1234,
        info: OmniAuth::AuthHash::InfoHash.new(email: user.email))

  visit '/'
  click_link 'Sign Up with FB'
end
