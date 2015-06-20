现在的情况是，即使不确认发货，我（ seller ）也可以收到货款。但是可能如果不发货，那么货款就会到时候自动退回给 buyer 。


使用 PID/KEY 的时候，我曾经犯过一个低级错误。我其实有两个支付宝账户，一个是申请了担保交易接口的，一个没有，结果我用那个根本没有申请的账户登录，拿到了 PID/KEY ，这一对儿家伙用上之后，当我向支付宝发出请求的时候，支付宝返回的错误是 `错误代码 HAS_NO_PRIVILEGE` 。这个基本的意思，大概就是这个 PID 对应的用户根本就没跟我们签”担保交易接口“的使用协议呀。

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



