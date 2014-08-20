class PaymentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :confirm
  before_action :normalize_cybersource_params, only: :confirm

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
    redirect_to response_handler.run { |result| Rails.logger.info "WE ARE HERE #{result[:params]['payment_token']}" }
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
    signer = CybersourceSigner.new(profile)
    signature_checker = SignatureChecker.new(profile, params, true)
    signature_checker.run!
    # This can also be called with a block, which will return results for logging
    #signature_checker.run! { |result| Rails.logger.info result}
    @payment = Payment.new(signer, profile, params)
  rescue Exceptions::CybersourceryError => e
    flash.now[:alert] = e.message
    render :error
  end
end
