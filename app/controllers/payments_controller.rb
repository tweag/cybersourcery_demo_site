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
  # TODO: We will check for errors, provide logging hooks, and redirect the user per the profile
  # settings (or show them a custom message?)
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
    # TODO: this won't work - we need the params from the original request to #pay - see Penn code for this
    fielder = SignedFieldsFielder.new(signer, profile, params)
    fielder.check_signature!
    @payment = Payment.new(fielder, profile)
    render :new
  end

  private

  def normalize_cybersource_params
    params.keys.each do |key|
      params[key[4..-1]] = params[key] if key =~ /^req_/
    end
  end

end
