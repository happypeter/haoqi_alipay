HaoqiAlipay::Application.routes.draw do
  post 'orders/notify'
  get 'orders/done'
  resources :orders
  post '/checkout' => "orders#checkout"
  root :to => "orders#new"
end
