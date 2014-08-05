module ProfilesHelper
  def transaction_types
    types = ['authorization', 'authorization,create_payment_token', 'sale', 'sale,create_payment_token']
    types.collect { |type| [type, type]}
  end

end
