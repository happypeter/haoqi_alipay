Rails.application.routes.draw do
  get "/orders/done" => "orders#done"
  post "/orders/alipay_notify" => "orders#alipay_notify"
  get "order/:out_trade_no" => "orders#show"
  resources :orders
  resources :cups
  root 'cups#index'
end
