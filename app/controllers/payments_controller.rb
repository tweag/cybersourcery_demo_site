class PaymentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def new
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    @payment = Payment.new(signer, profile)
  end

  # This receives a POST from Cybersource, which handles the transaction itself.
  # TODO: We will check for errors, provide logging hooks, and redirect the user per the profile
  # settings (or show them a custom message?)
  def create
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    response_handler = CybersourceResponseHandler.new(params, signer)
    redirect_to response_handler.run
  rescue Exception => e
    flash.now[:alert] = e.message
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    @payment = Payment.new(signer, profile)
    render :new
  end
end
