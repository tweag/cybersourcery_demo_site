class CartsController < ApplicationController
  def new
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    @signed_fields = signer.sign_cart_fields({amount: 100})
  end
end
