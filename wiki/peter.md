现在的情况是，即使不确认发货，我（ seller ）也可以收到货款。但是可能如果不发货，那么货款就会到时候自动退回给 buyer 。


----
Q: 错误原因？

>调试错误，请回到请求来源地，重新发起请求。
>错误代码 HAS_NO_PRIVILEGE

上面这个错误是在我添加了自己的 pid/key 之后，发起付款请求的时候出现的，不知道为啥？

A: 我是用 happycasts@gmail.com 这个支付宝账户申请的担保交易接口。但是刚才我是用 happypeter1983@gmail.com 获取的 PID/KEY 而这个账户下根本就没有申请担保交易。(用自己的账户登录支付宝，到 https://b.alipay.com/ 点击“我的商家服务”标签，可以查看自己已经申请的商家服务)

-------------
Q: 同步通知的 orders#show 错误？

http://local.dev:3000/orders/done?buyer_email=happypeter1983%40gmail.com&buyer_id=2088402465245110&discount=0.00&gmt_create=2015-06-18+11%3A31%3A58&gmt_logistics_modify=2015-06-18+11%3A31%3A58&gmt_payment=2015-06-18+11%3A32%3A29&is_success=T&is_total_fee_adjust=N&logistics_fee=0.00&logistics_payment=SELLER_PAY&logistics_type=DIRECT&notify_id=RqPnCoPT3K9%252Fvwbh3InSMkSDF8ujelMNPm02L8HfX%252FHuPeBMBss1XAlxIedTFTQmNSXh&notify_time=2015-06-18+11%3A32%3A33&notify_type=trade_status_sync&out_trade_no=1434598288&payment_type=1&price=4.50&quantity=1&receive_address=none&receive_mobile=100000000000&receive_name=none&receive_zip=100000&seller_actions=SEND_GOODS&seller_email=happycasts%40gmail.com&seller_id=2088012362182973&subject=%E7%99%BD%E8%89%B2%E6%9D%AF%E5%AD%90&total_fee=4.50&trade_no=2015061800001000110057346192&trade_status=WAIT_SELLER_SEND_GOODS&use_coupon=N&sign=83071fa6d207f085ca24c59584590973&sign_type=MD5

这个是同步通知链接，那在我的 routes.rb 中

     get "/orders/done" => "orders#done"

而在 orders#done 方法中，并没有使用 orders#show 啊

A: 到 routes.rb 中 把 `resources :orders` 放到 `get "/orders/done"` 之后就行了，这是个低级错误。


---------
Q: 我申请的担保交易，用视频中代码，出现 ILLEGAL_PARTNER_EXTERFACE ，好像是服务类型错误，怎么办?

A:



