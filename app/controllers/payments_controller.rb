class PaymentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :confirm
  before_action :normalize_cybersource_params, only: :confirm

  def pay
    setup_payment_form
  end

  # This receives a POST from Cybersource, which handles the transaction itself.
  def confirm
    profile = CybersourceProfile.new('pwksgem')
    signature_checker = SignatureChecker.new(profile, params)
    response_handler = CybersourceResponseHandler.new(params, signature_checker, profile)
    redirect_to response_handler.run
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
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    signature_checker = SignatureChecker.new(profile, params, true)
    signature_checker.run!
    @payment = Payment.new(signer, profile, params)
  rescue Exceptions::CybersourceryError => e
    flash.now[:alert] = e.message
    render :error
  end
end
