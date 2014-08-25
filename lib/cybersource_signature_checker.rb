class CybersourceSignatureChecker < SignatureChecker

  def signed_field_names
    @params['signed_field_names']
  end


  def signature
    @params['signature']
  end
end
