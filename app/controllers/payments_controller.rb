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

  # This receives a POST from Cybersource, which handles the transaction itself.
  def confirm
    profile = Profile.new('pwksgem')
    signature_checker = SignatureChecker.new(profile, params)
    response_handler = CybersourceResponseHandler.new(params, signature_checker, profile)
    #redirect_to response_handler.run
    # This can also be called with a block, which will return results for logging
    redirect_to response_handler.run { |result| Rails.logger.info result[:params]['payment_token'] }
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
    signer = CybersourceSigner.new(profile, UNSIGNED_FIELD_NAMES)
    signature_checker = SignatureChecker.new(profile, params, true)
    signature_checker.run!
    # This can also be called with a block, which will return results for logging
    #signature_checker.run! { |result| Rails.logger.info result }
    Rails.logger.debug params
    @payment = Payment.new(signer, profile, params)
  rescue Exceptions::CybersourceryError => e
    flash.now[:alert] = e.message
    render :error
  end
end
