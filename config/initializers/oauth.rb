Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '525110200893323', '42ee4b1360914e8617cbd059816f0657',
           scope: 'email', display: 'page'

  on_failure do
    [302, {'Location' => '/'}, []]
  end
end
