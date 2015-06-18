# coding: utf-8
class OrdersController < ApplicationController
  before_action :update_order, only: [ :done, :alipay_notify]

  def new
    @cup = Cup.find(params[:cup_id]) if params[:cup_id].present?
    @order = Order.new
    @out_trade_no = Time.now.to_i.to_s
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order.pay_url
    end
  end

  def done
    if @order.trade_status == "finished"
      flash[:notice] = "恭喜你，付款成功了！"
    end
    redirect_to :root
  end

  def alipay_notify
    if @order.trade_status == "finished"
      render text: 'success'
    end
  end

  private

  def order_params
    params.require(:order).permit(:course_id, :out_trade_no, :trade_status, :subject, :total_fee)
  end

  def update_order
    options = {
      :trade_no       => params[:trade_no],
      :logistics_name => 'course',
      :transport_type => 'DIRECT'
    }
    @order = Order.find_by_out_trade_no(params[:out_trade_no])
    notify_params = params.except(*request.path_parameters.keys)

    if (@order.trade_status != "finished") && Alipay::Notify.verify?(notify_params)
      if params[:trade_status] == "WAIT_SELLER_SEND_GOODS"
        Alipay::Service.send_goods_confirm_by_platform(options)
        @order.update_attributes(trade_status: "finished", total_fee: params[:total_fee])
      end
    end
  end
end
