# encoding: utf-8
class OrdersController < ApplicationController
  before_filter :update_order, :only => [:done, :notify]

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
      :return_url        => Settings.alipay.return_url,
      :notify_url        => Settings.alipay.notify_url
    }
    redirect_to AlipayDualfun.trade_create_by_buyer_url(options)
  end

  def done
    notify_params = params.except(*request.path_parameters.keys)
    if AlipayDualfun.notify_verify?(notify_params)
      flash[:notice] = "付款成功啦!"
    else
      flash[:notice] = "付款error啦!"
    end
    redirect_to :root
  end

  def notify
    render text: 'success'
  end

  private
    def update_order
      notify_params = params.except(*request.path_parameters.keys)
      if AlipayDualfun.notify_verify?(notify_params)
        order = Order.find_by_out_trade_no(params[:out_trade_no])
        if params[:trade_status] == 'TRADE_FINISHED' && order.trade_status != 'TRADE_FINISHED'
          order.update_attributes(trade_status: params[:trade_status])
        end
      end
    end
end
