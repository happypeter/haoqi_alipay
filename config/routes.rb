HaoqiAlipay::Application.routes.draw do
  resources :orders
  post '/checkout' => "orders#checkout"
  root :to => "orders#new"
end
