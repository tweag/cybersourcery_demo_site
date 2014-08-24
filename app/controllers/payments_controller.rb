class PaymentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :confirm
  before_action :normalize_cybersource_params, only: :confirm

  UNSIGNED_FIELD_NAMES = %i[
    bill_to_email
    bill_to_forename
    bill_to_surname
    bill_to_address_line1
    bill_to_address_line2
    bill_to_address_country
    bill_to_address_state
    bill_to_address_postal_code
    bill_to_address_city
    card_cvn
    card_expiry_date
    card_number
    card_type
  ]

  def pay
    setup_payment_form
  end

  # This receives a POST from the hidden form dynamically rendered in the user's browser by
  # Cybersource.
  def confirm
    profile = Profile.new('pwksgem')
    signature_checker = CybersourceSignatureChecker.new({ profile: profile, params: params })
    signature_checker.run!
    flash.now[:notice] = ReasonCodeChecker::run!(params[:reason_code])
    serializer = MerchantDataSerializer.new
    @merchant_data = serializer.deserialize(params)
    #redirect_to profile.success_url # this is optional
  rescue Exceptions::CybersourceryError => e
    flash.now[:alert] = e.message
    setup_payment_form
    render :pay
  end

  private

  def normalize_cybersource_params
    params.keys.each do |key|
      params[key[4..-1]] = params[key] if key =~ /^req_/
    end
  end

  def setup_payment_form
    profile = Profile.new('pwksgem')
    signature_checker = CartSignatureChecker.new({ profile: profile, params: params, session: session})
    signature_checker.run!
    signer = CybersourceSigner.new(profile, UNSIGNED_FIELD_NAMES)
    @payment = MyPayment.new(signer, profile, params)
  rescue Exceptions::CybersourceryError => e
    flash.now[:alert] = e.message
    render :error
  end
end
