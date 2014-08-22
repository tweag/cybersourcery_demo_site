# This will not be part of the gem. The idea is you can subclass Payment for any additional fields
# you want in your form
class MyPayment < Payment
  attr_accessor :bill_to_phone, :card_cvn
  validates_presence_of :card_cvn
end
