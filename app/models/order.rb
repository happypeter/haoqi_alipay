class Order < ActiveRecord::Base
  def pay_url
    Alipay::Service.create_partner_trade_by_buyer_url({
      out_trade_no:      out_trade_no,
      subject:           subject,
      price:             total_fee,
      quantity:          1,
      logistics_type:    'DIRECT',
      logistics_fee:     '0',
      logistics_payment: 'SELLER_PAY',
      receive_name:      'none',
      receive_address:   'none',
      receive_zip:       '100000',
      receive_mobile:    '100000000000',
      return_url:        'http://alipay.haoqicat.com/orders/done',
      notify_url:        'http://alipay.haoqicat.com/orders/notify'
    })
  end
end
