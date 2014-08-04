class PaymentsController < ApplicationController
  def new
    # TODO: may need to determine this dynamically in some fashion
    @profile = Profile.find_by(access_key: '839d4d3b1cef3e04bd2981997714803b')
    signer = CybersourceSigner.new(@profile)
    @signed_form_data = signer.signed_form_data
  end

  # This receives a POST from Cybersource, which handles the transaction itself.
  # TODO: We will check for errors, provide logging hooks, and redirect the user per the profile
  # settings (or show them a custom message?)
  def create
    profile = Profile.find_by(access_key: '839d4d3b1cef3e04bd2981997714803b')
    response_handler = CybersourceResponseHandler.new(params, profile)
    redirect_to response_handler.run
  rescue Exception => e
    flash.now[:alert] = e.message
    @profile = Profile.find_by(access_key: '839d4d3b1cef3e04bd2981997714803b')
    signer = CybersourceSigner.new(@profile)
    @signed_form_data = signer.signed_form_data
    render :new
  end
end
