EshareVerify::Application.routes.draw do
  get '/check/:code' => 'check#index'
  get '/'         => 'verify_codes#login'
  get '/login'    => 'verify_codes#login'
  post 'do_login' => 'verify_codes#do_login'
  get '/logout'   => 'verify_codes#logout'
  resources :verify_codes
end
