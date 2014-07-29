class PaymentsController < ApplicationController
  def new
    # TODO: will need to determine this dynamically in some fashion
    @profile = Profile.find_by(access_key: '839d4d3b1cef3e04bd2981997714803b')
  end
end
