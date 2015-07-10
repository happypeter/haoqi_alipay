class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  # 没有上面这一行，当接受 alipay.com 发过来的 POST 请求的时候，后台 log 中会报错 `Can't verify CSRF token authenticity`
  before_action :update_order, only: [ :done, :notify]
  def new
    @cup = Cup.find(params[:cup_id])
    @order = Order.new
    @out_trade_no = Time.now.to_i.to_s
  end

  def create
    @order = Order.new
    @order.out_trade_no = params[:out_trade_no]
    @order.cup_id = params[:cup_id]
    @order.subject = params[:subject]
    @order.total_fee = params[:total_fee]
    @order.save
    redirect_to @order.pay_url
  end

  def show
    @order = Order.find_by_out_trade_no(params[:out_trade_no])
  end

  def done
    redirect_to '/orders/' + @order.out_trade_no
  end

  def notify
    if @order.trade_status == "finished"
      render text: 'success'
    else
      render text: 'working'
    end
  end

  private
  def update_order
    options = {
      :trade_no       => params[:trade_no],
      :logistics_name => 'runrunrun',
      :transport_type => 'DIRECT' # 文档上虽然标明“可空”，但是同时"与 create_transport_type" 不能同时为空
    }
    @order = Order.find_by_out_trade_no(params[:out_trade_no])
    notify_params = params.except(*request.path_parameters.keys)
    if (@order.trade_status != "finished") && Alipay::Notify.verify?(notify_params)
      if params[:trade_status] == "WAIT_SELLER_SEND_GOODS"
        Alipay::Service.send_goods_confirm_by_platform(options)
        @order.update_attributes(trade_status: "finished")
      end
    end
  end
end
