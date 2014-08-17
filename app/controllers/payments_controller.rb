class PaymentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :confirm
  before_action :normalize_cybersource_params, only: :confirm

  def pay
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    fielder = SignedFieldsFielder.new(signer, profile, params)
    fielder.check_signature!
    @payment = Payment.new(fielder, profile)
  end

  # This receives a POST from Cybersource, which handles the transaction itself.
  # TODO: provide logging hooks
  def confirm
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    fielder = SignedFieldsFielder.new(signer, profile, params)
    response_handler = CybersourceResponseHandler.new(params, fielder, profile)
    redirect_to response_handler.run
  rescue Exception => e
    flash.now[:alert] = e.message
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    fielder = SignedFieldsFielder.new(signer, profile, params)
    fielder.check_signature!
    @payment = Payment.new(fielder, profile)
    render :pay
  end

  private

  def normalize_cybersource_params
    params.keys.each do |key|
      params[key[4..-1]] = params[key] if key =~ /^req_/
    end
  end

end
