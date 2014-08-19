require 'rails_helper'

describe SignatureChecker do
  let(:profile) { double :profile, secret_key: 'SECRET_KEY' }
  let(:signature) { 'vWV/HxXelIWsO0tkLZe+H1S6tXflgPz79udP0uXrvPI=' }

  context 'Checking signature when returning from a successful Cybersource transaction' do
    let(:params) do
      {
        'signed_field_names' => 'access_key,profile_id,payment_method',
        'access_key' => 'ACCESS_KEY',
        'profile_id' => 'pwksgem',
        'payment_method' => 'sale',
        'signature' => signature,
        'foo' => 'bar'
      }
    end

    describe '#run!' do
      it 'does not raise an exception when the signatures match' do
        checker = SignatureChecker.new(profile, params)
        expect(checker.run!).to be_nil
      end

      it 'raises an exception when the signatures do not match' do
        params['access_key'] = 'TAMPERED_KEY'
        checker = SignatureChecker.new(profile, params)
        expect { checker.run! }.to raise_exception(
          Exceptions::CybersourceryError,
          'Detected possible data tampering. Signatures do not match.'
        )
      end
    end
  end

  context 'Checking signature when coming from the shopping cart form' do
    let(:params) do
      {
        'merchant_defined_data99' => 'access_key,profile_id,payment_method',
        'access_key' => 'ACCESS_KEY',
        'profile_id' => 'pwksgem',
        'payment_method' => 'sale',
        'merchant_defined_data100' => signature,
        'foo' => 'bar'
      }
    end

    describe '#run!' do
      it 'does not raise an exception when the signatures match' do
        checker = SignatureChecker.new(profile, params, true)
        expect(checker.run!).to be_nil
      end

      it 'raises an exception when the signatures do not match' do
        params['access_key'] = 'TAMPERED_KEY'
        checker = SignatureChecker.new(profile, params, true)
        expect { checker.run! }.to raise_exception(
          Exceptions::CybersourceryError,
          'Detected possible data tampering. Signatures do not match.'
        )
      end
    end
  end
end
