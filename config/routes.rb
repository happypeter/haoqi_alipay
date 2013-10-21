HaoqiAlipay::Application.routes.draw do
  get 'orders/done'
  resources :orders
  post '/checkout' => "orders#checkout"
  root :to => "orders#new"
end
