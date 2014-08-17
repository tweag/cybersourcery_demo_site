class CartsController < ApplicationController
  def new
    profile = CybersourceProfile.new('pwksgem')
    signer = CybersourceSigner.new(profile)
    fielder = SignedFieldsFielder.new(signer, profile)
    @signed_fields = fielder.sign_arbitrary_fields({amount: 100})
  end
end
