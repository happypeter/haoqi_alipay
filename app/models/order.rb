class Order < ActiveRecord::Base
  attr_accessible :out_trade_no, :price, :quantity, :subject, :trade_status
end
