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

end
