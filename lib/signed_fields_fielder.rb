class SignedFieldsFielder
  attr_reader :signer, :profile, :params

  def initialize(signer, profile, params = nil)
    @signer = signer
    @profile = profile
    @params = params
  end

  def sign_arbitrary_fields(fields)
    fields[:signed_field_names] = fields.keys.join(',')
    @signer.form_data = fields
    @signer.signed_form_data
  end

  def check_signature
    signed_fields_keys = @params.fetch('signed_field_names').split(',')
    signed_fields = @params.select { |k, v| signed_fields_keys.include? k }
    signature_message = CybersourceSigner.signature_message(signed_fields, signed_fields_keys)
    signature_check = CybersourceSigner::Signer.signature(signature_message, @profile.secret_key)
    signature_check == @params['signature']
  end

  def check_signature!
    raise 'Signature does not match' unless check_signature
  end

  def sign_cybersource_fields
    @signer.add_cybersource_fields(@params)
    @signer.signed_form_data
  end
end
