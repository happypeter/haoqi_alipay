---
layout: book
title: 异步通知
---

视频：08_notify.mov

### 内容简介

异步通知的后台 log 调试。与同步通知协同工作，返回 success 停止后续重复发送的同步通知。

### 项目部署到服务器

同步通知时，如果用户不小心把页面关了，这样通知就会失败，所以咱们还需要异步通知。

步骤参考 <http://happypeter.github.io/rails-tricks/14_deployment.html> 。部署后要把本地的 `alipay.rb` 文件拷贝到服务器上，因为里面包含 PID/KEY 。

另外就是要修改同步通知的链接

{% highlight ruby %}
--- return_url:        'http://local.dev:3000/orders/done'
+++ return_url:        'http://alipay.haoqicat.com/orders/done'
{% endhighlight %}

### 添加 notify_url

打开 order.rb 文件，添加 notify_url 进来

{% highlight ruby %}
+++       notify_url:        'http://alipay.haoqicat.com/orders/notify'
{% endhighlight %}

这样，提交信息到到支付宝，在买家用自己的账户登录支付宝之后，真正付款之前，就可以收到异步通知了。如下

{% highlight console %}
[2015-07-01T22:31:17.158836 #1407]  INFO -- : Started POST "/orders/notify" for 110.75.225.151 at 2015-07-01 22:31:17 -0400
I, [2015-07-01T22:31:17.162101 #1407]  INFO -- : Processing by OrdersController#notify as HTML
I, [2015-07-01T22:31:17.162614 #1407]  INFO -- :   Parameters: {"discount"=>"0.00", "payment_type"=>"1", "subject"=>"白色杯子", "trade_no"=>"2015070200001000110058805905", "buyer_email"=>"happypeter1983@gmail.com", "gmt_create"=>"2015-07-02 10:31:11", "notify_type"=>"trade_status_sync", "quantity"=>"1", "out_trade_no"=>"1435804253", "seller_id"=>"2088012362182973", "notify_time"=>"2015-07-02 10:31:11", "trade_status"=>"WAIT_BUYER_PAY", "is_total_fee_adjust"=>"Y", "total_fee"=>"4.50", "seller_email"=>"happycasts@gmail.com", "price"=>"4.50", "buyer_id"=>"2088402465245110", "notify_id"=>"a69c092adb596cffa53830839c705a182m", "use_coupon"=>"N", "sign_type"=>"MD5", "sign"=>"93cd627b390497faece84b35c06daf8c"}
{% endhighlight %}

注意，此时的通知中包含
`"trade_status"=>"WAIT_BUYER_PAY"` ，所以可以通过这个来判断，进而忽略这次通知。

另外，log 中还会有 `Can't verify CSRF token authenticity` 这样的错误。这是因为直接 POST 内容到 rails 会触发它的安全保护机制。咱们这里暂时不需要这一层安全机制，所以可以通知 rails 取消这次安全检查，也就是到 orders_controller.rb 文件中添加 `skip_before_action :verify_authenticity_token` 。这样 log 中就不会有报错信息了。

### 修改代码

如果买家输入了自己的支付密码，完成付款后，可以看到后台 log 如下：

{% highlight console %}
 Parameters: {"discount"=>"0.00", "logistics_type"=>"DIRECT", "receive_zip"=>"100000", "payment_type"=>"1", "subject"=>"白色杯子", "logistics_fee"=>"0.00", "trade_no"=>"2015070200001000110058816907", "buyer_email"=>"happypeter1983@gmail.com", "gmt_create"=>"2015-07-02 11:49:27", "notify_type"=>"trade_status_sync", "quantity"=>"1", "logistics_payment"=>"SELLER_PAY", "out_trade_no"=>"1435808875", "seller_id"=>"2088012362182973", "notify_time"=>"2015-07-02 11:57:54", "trade_status"=>"WAIT_SELLER_SEND_GOODS", "is_total_fee_adjust"=>"N", "gmt_payment"=>"2015-07-02 11:57:54", "total_fee"=>"4.50", "seller_email"=>"happycasts@gmail.com", "price"=>"4.50", "buyer_id"=>"2088402465245110", "receive_mobile"=>"100000000000", "gmt_logistics_modify"=>"2015-07-02 11:49:27", "notify_id"=>"df28cd9f1547cc044dd857c4fadd09fe2m", "receive_name"=>"none", "use_coupon"=>"N", "sign_type"=>"MD5", "sign"=>"5851ac8f15f83f4f2322b3f2371bbeb0", "receive_address"=>"none"}
{% endhighlight %}

注意这次的 trade_status 是 `WAIT_SELLER_SEND_GOODS` ， 同时，同步通知中也会看到同样的交易状态。我们可以根据这个交易状态来把代码写完善。


### 异步通知停不下来

{% highlight console %}
I, [2015-07-02T00:47:46.639225 #5280]  INFO -- : Started POST "/orders/notify" for 110.75.225.68 at 2015-07-02 00:47:46 -0400
I, [2015-07-02T00:47:46.641940 #5280]  INFO -- : Processing by OrdersController#notify as HTML
I, [2015-07-02T00:47:46.642349 #5280]  INFO -- :   Parameters: {"discount"=>"0.00", "logistics_type"=>"DIRECT", "receive_zip"=>"100000", "payment_type"=>"1", "subject"=>"绿色杯子", "logistics_fee"=>"0.00", "trade_no"=>"2015070200001000110058823112", "buyer_email"=>"happypeter1983@gmail.com", "gmt_create"=>"2015-07-02 12:41:40", "notify_type"=>"trade_status_sync", "quantity"=>"1", "logistics_payment"=>"SELLER_PAY", "out_trade_no"=>"1435812055", "seller_id"=>"2088012362182973", "notify_time"=>"2015-07-02 12:47:44", "trade_status"=>"WAIT_SELLER_SEND_GOODS", "is_total_fee_adjust"=>"N", "gmt_payment"=>"2015-07-02 12:47:44", "total_fee"=>"7.50", "seller_email"=>"happycasts@gmail.com", "price"=>"7.50", "buyer_id"=>"2088402465245110", "receive_mobile"=>"100000000000", "gmt_logistics_modify"=>"2015-07-02 12:41:40", "notify_id"=>"df153fe2758d42202fb216ebd65b7b442m", "receive_name"=>"none", "use_coupon"=>"N", "sign_type"=>"MD5", "sign"=>"3bf7f4ede0e34738c46c1b5aad8141a6", "receive_address"=>"none"}
I, [2015-07-02T00:47:49.794592 #5280]  INFO -- :   Rendered text template (0.1ms)
I, [2015-07-02T00:47:49.795632 #5280]  INFO -- : Completed 200 OK in 3153ms (Views: 2.0ms | ActiveRecord: 19.1ms)
I, [2015-07-02T00:47:50.187412 #5280]  INFO -- : Started POST "/orders/notify" for 110.75.225.68 at 2015-07-02 00:47:50 -0400
I, [2015-07-02T00:47:50.192454 #5280]  INFO -- : Processing by OrdersController#notify as HTML
I, [2015-07-02T00:47:50.193065 #5280]  INFO -- :   Parameters: {"gmt_send_goods"=>"2015-07-02 12:47:48", "discount"=>"0.00", "logistics_type"=>"DIRECT", "receive_zip"=>"100000", "payment_type"=>"1", "subject"=>"绿色杯子", "logistics_fee"=>"0.00", "trade_no"=>"2015070200001000110058823112", "buyer_email"=>"happypeter1983@gmail.com", "gmt_create"=>"2015-07-02 12:41:40", "notify_type"=>"trade_status_sync", "quantity"=>"1", "logistics_payment"=>"SELLER_PAY", "out_trade_no"=>"1435812055", "seller_id"=>"2088012362182973", "notify_time"=>"2015-07-02 12:47:48", "trade_status"=>"WAIT_BUYER_CONFIRM_GOODS", "is_total_fee_adjust"=>"N", "gmt_payment"=>"2015-07-02 12:47:44", "total_fee"=>"7.50", "seller_email"=>"happycasts@gmail.com", "price"=>"7.50", "buyer_id"=>"2088402465245110", "receive_mobile"=>"100000000000", "gmt_logistics_modify"=>"2015-07-02 12:41:40", "notify_id"=>"2e5b6dbf781f8faa16a4f66d5b319e462m", "receive_name"=>"none", "use_coupon"=>"N", "sign_type"=>"MD5", "sign"=>"4e60d6a53b976db7b18323f176414365", "receive_address"=>"none"}
I, [2015-07-02T00:47:50.199790 #5280]  INFO -- :   Rendered text template (0.0ms)
I, [2015-07-02T00:47:50.200630 #5280]  INFO -- : Completed 200 OK in 7ms (Views: 1.2ms | ActiveRecord: 1.5ms)
I, [2015-07-02T00:49:53.605616 #5280]  INFO -- : Started GET "/orders/1435812055" for 120.6.73.136 at 2015-07-02 00:49:53 -0400
I, [2015-07-02T00:49:53.608144 #5280]  INFO -- : Processing by OrdersController#show as HTML
I, [2015-07-02T00:49:53.608438 #5280]  INFO -- :   Parameters: {"out_trade_no"=>"1435812055"}
I, [2015-07-02T00:49:53.613472 #5280]  INFO -- :   Rendered orders/show.html.erb within layouts/application (0.6ms)
I, [2015-07-02T00:49:53.615526 #5280]  INFO -- : Completed 200 OK in 7ms (Views: 3.6ms | ActiveRecord: 0.3ms)
I, [2015-07-02T00:55:39.961513 #5280]  INFO -- : Started POST "/orders/notify" for 110.75.225.63 at 2015-07-02 00:55:39 -0400
I, [2015-07-02T00:55:39.964848 #5280]  INFO -- : Processing by OrdersController#notify as HTML
I, [2015-07-02T00:55:39.965264 #5280]  INFO -- :   Parameters: {"discount"=>"0.00", "payment_type"=>"1", "subject"=>"绿色杯子", "trade_no"=>"2015070200001000110058823112", "buyer_email"=>"happypeter1983@gmail.com", "gmt_create"=>"2015-07-02 12:41:40", "notify_type"=>"trade_status_sync", "quantity"=>"1", "out_trade_no"=>"1435812055", "seller_id"=>"2088012362182973", "notify_time"=>"2015-07-02 12:55:38", "trade_status"=>"WAIT_BUYER_PAY", "is_total_fee_adjust"=>"Y", "total_fee"=>"7.50", "seller_email"=>"happycasts@gmail.com", "price"=>"7.50", "buyer_id"=>"2088402465245110", "notify_id"=>"23fa30cfb19cd61fede6aedf8fc1e2112m", "use_coupon"=>"N", "sign_type"=>"MD5", "sign"=>"19a983d3e0428dd78c757ddd6b63f453"}
I, [2015-07-02T00:55:39.968283 #5280]  INFO -- :   Rendered text template (0.0ms)
I, [2015-07-02T00:55:39.968931 #5280]  INFO -- : Completed 200 OK in 3ms (Views: 1.0ms | ActiveRecord: 0.3ms)

{% endhighlight %}

更新：收到了三次异步通知，后面又四个小时过去了，没有收到新的异步通知。
