class SignedFieldsFielder
  attr_reader :signer, :profile, :params

  def initialize(signer, profile, params = nil)
    @signer = signer
    @profile = profile
    @params = params
  end

  # We're reserving merchant defined data fields 99 and 100 for fields we will need in the case of
  # a failed transaction, so we can re-create the state of the submission from the cart to the
  # credit card payment form.
  def sign_arbitrary_fields(fields)
    fields[:signed_field_names] = fields.keys.join(',')
    fields[:merchant_defined_data99] = fields[:signed_field_names]
    @signer.form_data = fields
    signed_form_data = @signer.signed_form_data
    signed_form_data[:merchant_defined_data100] = signed_form_data[:signature]
    signed_form_data
  end

  def check_signature
    signed_field_names = @params['merchant_defined_data99'].present? ? @params['merchant_defined_data99'] : @params['signed_field_names']
    signature = @params['merchant_defined_data100'].present? ? @params['merchant_defined_data100'] : @params['signature']
    signed_fields_keys = signed_field_names.split(',')
    signed_fields = @params.select { |k, v| signed_fields_keys.include? k }
    signature_message = CybersourceSigner.signature_message(signed_fields, signed_fields_keys)
    signature_check = CybersourceSigner::Signer.signature(signature_message, @profile.secret_key)
    signature_check == signature
  end

  def check_signature!
    raise 'Signature does not match' unless check_signature
  end

  def sign_cybersource_fields
    @signer.add_cybersource_fields(@params)
    @signer.signed_form_data
  end
end
