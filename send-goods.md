---
title: 自动发货
---

视频：07_send_goods.mov

### 内容简介
如果不发货，还是拿不到钱的。这里介绍如何调用接口，实现用代码自动发货。

### 发送货物

这里会用到支付宝的确认发货接口，构造请求参数，发送数据，通知支付宝系统已经给用户发送货物。
而此时支付宝中的订单状态显示为 `确认收货`，客户登录支付宝后，点击 `确认发货` 按钮，货款自动进入你的支付宝账户。
其实，在这个人人网购的年代，这种付费方式，我们太熟悉了。

以实物商品为例，比方说，你在淘宝上买了一件心仪的裙子，卖家通过快递，把裙子送到你手中。

要是虚拟商品，比如说电子书，视频课程，邀请码等等，快递哥就歇了，编码更改商品状态就好了，具体操作
由你自己的业务逻辑决定。

如果不发货，那么钱最终咱们还是拿不到的。

### 交易状态变更

{% highlight ruby %}
def done
  options = {
    :trade_no       => params[:trade_no],
    :logistics_name => 'runrunrun',
    :transport_type => 'DIRECT' # 文档上虽然标明“可空”，但是不传还是不行，应该是支付接口的一个小 BUG
  }
  Alipay::Service.send_goods_confirm_by_platform(options)
  order = Order.find_by_out_trade_no(params[:out_trade_no])
  order.update_attributes(trade_status: "finished")
  redirect_to '/orders/' + order.out_trade_no
end
{% endhighlight %}


{% highlight erb %}
<% if @order.trade_status == "finished" %>
 已付款
<% else %>
 未付款
<% end %>
{% endhighlight %}

注：关于 `transport_type` 的问题，答案是

> 这个字段跟另一个字段“不能同时为空”

详细内容参考这里的讨论： <https://github.com/chloerei/alipay/issues/45> 。
