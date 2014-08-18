require 'rails_helper'

describe CybersourceResponseHandler do
  describe '#check_for_transaction_errors' do
    it 'returns nil if the transaction was successful' do
      response_handler = CybersourceResponseHandler.new(
        { 'reason_code' => '100'},
        double('signature_checker'),
        double('profile')
      )
      expect(response_handler.check_for_transaction_errors).to eq nil
    end

    it 'returns an error message for a known error code' do
      response_handler = CybersourceResponseHandler.new(
        { 'reason_code' => '101'},
        double('signature_checker'),
        double('profile')
      )
      expect { response_handler.check_for_transaction_errors }.to raise_exception(
        Exceptions::CybersourceryError,
        'Declined: The request is missing one or more required fields.'
      )
    end

    it 'returns an error message for an unknown error code' do
      response_handler = CybersourceResponseHandler.new(
        { 'reason_code' => '600'},
        double('signature_checker'),
        double('profile')
      )
      expect { response_handler.check_for_transaction_errors }.to raise_exception(
        Exceptions::CybersourceryError,
        'Declined: unknown reason (code 600)'
      )
    end
  end
end
