HaoqiAlipay::Application.routes.draw do
  resources :orders
  root :to => "orders#new"
end
