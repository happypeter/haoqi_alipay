Rails.application.routes.draw do
  get "/orders/done" => "orders#done"
  post "/orders/alipay_notify" => "orders#alipay_notify"
  resources :orders
  resources :cups
  root 'cups#index'
end
