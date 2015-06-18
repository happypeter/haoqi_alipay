class Cup < ActiveRecord::Base
 has_many :orders

 def paid?
   Order.where(trade_status: 'finished', course_id: self.id).first.present?
 end
end
