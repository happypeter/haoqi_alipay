class Order < ActiveRecord::Base
  belongs_to :cup

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
      return_url:        'http://local.dev:3000/orders/done',
      # notify_url:        'http://hc.dev:3000/orders/alipay_notify'
    })
  end
end
