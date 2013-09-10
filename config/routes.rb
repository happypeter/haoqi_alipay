HaoqiAlipay::Application.routes.draw do
  get "orders/new"

  get "info/welcome"

  root :to => "info#welcome"
end
