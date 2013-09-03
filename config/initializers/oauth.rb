Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'],
           scope: 'email', display: 'page'

  on_failure do
    [302, {'Location' => '/'}, []]
  end
end
