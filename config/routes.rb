HaoqiAlipay::Application.routes.draw do
  get "info/welcome"

  root :to => "info#welcome"
end
