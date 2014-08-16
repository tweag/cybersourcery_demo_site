class CartsController < ApplicationController
  def new
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    @amount = '100'
    signature_keys = [:amount, :signed_field_names ]
    params_with_sym_keys = { amount: @amount, signed_field_names: 'amount' }
    signer.form_data = params_with_sym_keys.select { |k, v| signature_keys.include? k }
    @signature = signer.signed_form_data[:signature]

  end
end
