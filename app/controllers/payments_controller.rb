class PaymentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :confirm
  before_action :normalize_cybersource_params, only: :confirm

  def pay
    profile = CybersourceProfile.new('pwksgem')

    signature_keys = params[:signed_field_names].split(',')
    signature_elements = {
      'amount' => params[:amount],
      'signed_field_names' => params[:signed_field_names]
    }
    signature_message = CybersourceSigner.signature_message(signature_elements, signature_keys)
    signature_check = CybersourceSigner::Signer.signature(signature_message, profile.secret_key)

    unless signature_check == params[:signature]
      raise 'Detected tampering with the form data'
    end

    signer = CybersourceSigner.new(profile)
    @payment = Payment.new(signer, profile)
  end

  # This receives a POST from Cybersource, which handles the transaction itself.
  # TODO: We will check for errors, provide logging hooks, and redirect the user per the profile
  # settings (or show them a custom message?)
  def confirm
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    response_handler = CybersourceResponseHandler.new(params, signer, profile)
    redirect_to response_handler.run
  rescue Exception => e
    flash.now[:alert] = e.message
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    @payment = Payment.new(signer, profile)
    render :new
  end

  private

  def normalize_cybersource_params
    params.keys.each do |key|
      params[key[4..-1]] = params[key] if key =~ /^req_/
    end
  end

end
