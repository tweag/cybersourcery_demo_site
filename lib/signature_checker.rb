class SignatureChecker
  attr_reader :profile, :params, :type

  def self.new_cart_checker(profile, params)
    SignatureChecker.new(profile, params, 'cart')
  end

  def self.new_cybersource_checker(profile, params)
    SignatureChecker.new(profile, params, 'cybersource')
  end

  def initialize(profile, params, type)
    @profile = profile
    @params = params
    @type = type
  end

  def run
    self.send("#{@type}_signature") == CybersourceSigner::Signer.signature(signature_message, @profile.secret_key)
  end

  def run!
    raise Exceptions::CybersourceryError, 'Detected possible data tampering. Signatures do not match.' unless run
  end

  private

  def signature_message
    signed_fields_keys = self.send("#{@type}_signed_field_names").split(',')
    signed_fields = @params.select { |k, v| signed_fields_keys.include? k }
    CybersourceSigner.signature_message(signed_fields, signed_fields_keys)
  end

  def cart_signed_field_names
    @params['merchant_defined_data99']
  end

  def cybersource_signed_field_names
    @params['signed_field_names']
  end

  def cart_signature
    @params['merchant_defined_data100']
  end

  def cybersource_signature
    @params['signature']
  end
end
