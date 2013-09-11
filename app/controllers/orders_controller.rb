class OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = Order.create(params[:order])
    @order.out_trade_no = Time.now.to_i.to_s
    @order.save
    redirect_to @order
  end

  def show
    @order = Order.find(params[:id])
  end

  def checkout
     options = {
      :partner           => Settings.alipay.pid,
      :key               => Settings.alipay.secret,
      :seller_email      => Settings.alipay.seller_email,
      :out_trade_no      => params[:out_trade_no],
      :subject           => params[:subject],
      :price             => params[:price],
      :quantity          => params[:quantity],
    }
    redirect_to AlipayDualfun.trade_create_by_buyer_url(options)
  end
end
