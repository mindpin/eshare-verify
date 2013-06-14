EshareVerify::Application.routes.draw do
  get '/check/:code' => 'check#index'
  get '/zhi_ma_kai_men'         => 'verify_codes#login'
  get '/zhi_ma_kai_men/login'    => 'verify_codes#login'
  post '/zhi_ma_kai_men/do_login' => 'verify_codes#do_login'
  get '/zhi_ma_kai_men/logout'   => 'verify_codes#logout'
  get '/'                        => 'index#index'
  resources :verify_codes
end
