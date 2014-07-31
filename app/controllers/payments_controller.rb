class PaymentsController < ApplicationController
  def new
    # TODO: may need to determine this dynamically in some fashion
    @profile = Profile.find_by(access_key: '839d4d3b1cef3e04bd2981997714803b')
  end

  # This receives a POST from Cybersource, which handles the transaction itself.
  # TODO: We will check for errors, provide logging hooks, and redirect the user per the profile
  # settings (or show them a custom message?)
  def create

  end
end
