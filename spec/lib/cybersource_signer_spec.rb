require 'rails_helper'

describe CybersourceSigner do
  let(:profile) do
    Profile.new(
      name: 'Admissions Acceptance Fee',
      service: 'test',
      profile_id: 'acptfee',
      access_key: 'afd7d26021e53ad1a48f1ec10c528ec8',
      secret_key: '298e5f32e86e44ecab9c0f9c544ed2dbd42377605bd64cee85ea9d7c239babfabb664153975d49b3b6377cacf8343d282f34ba20b342482cbf892be121a3820524007662e8d54222b2ef50b2f535a2fa1556f9a257f54600bba3020ca66bf15dc327ec025ced4f23903d19435547001bd3a103b7577a4a6a998e588dbc4880bc'
    )
  end

  subject(:cybersource) { CybersourceSigner.new(profile) }

  describe '#form_data' do
    it 'sets the form_data fields' do
      form_data = cybersource.form_data

      # these two fields are generated each time
      expect(form_data[:transaction_uuid].length).to eq 32
      expect(form_data[:reference_number].length).to eq 32

      expect(cybersource.form_data).to match a_hash_including(
        access_key: 'afd7d26021e53ad1a48f1ec10c528ec8',
        profile_id: 'acptfee',
        payment_method: 'card',
        locale: 'en',
        transaction_type: 'sale',
        currency: 'USD',
        unsigned_field_names: 'bill_to_email,bill_to_forename,bill_to_surname,bill_to_address_line1,bill_to_address_line2,bill_to_address_country,bill_to_address_state,bill_to_address_postal_code,bill_to_address_city,card_cvn,card_expiry_date,card_number,card_type,commit',
        transaction_uuid: form_data[:transaction_uuid],
        reference_number: form_data[:reference_number],
        signed_field_names: 'access_key,profile_id,payment_method,locale,transaction_type,currency,unsigned_field_names,transaction_uuid,reference_number,signed_field_names,signed_date_time',
        signed_date_time: form_data[:signed_date_time]
      )
    end
  end

  describe '#signed_form_data' do
    class FakeSigner < OpenStruct
      def signature(message, secret_key)
        self.received_message = message
        self.received_secret_key = secret_key
        fake_signature
      end
    end

    let(:time) { Time.parse '2014-03-05 13:30:59:UTC' }
    let(:signature) { 'SUPERSECURESIGNATURE' }
    let(:signer) { FakeSigner.new(fake_signature: signature) }
    let(:cybersource) do
      CybersourceSigner.new(profile, signer)
    end

    subject! do
      cybersource.time = time
      cybersource.signed_form_data
    end

    it 'should have the correct signed date_time' do
      expect(subject[:signed_date_time]).to eq time
    end

    it 'should have the correct signature' do
      expect(subject[:signature]).to eq signature
    end

    it 'should get signature from signer' do
      form_data = cybersource.form_data
      keys = cybersource.form_data[:signed_field_names].split(',').map { |e| e.to_sym }
      message = CybersourceSigner.signature_message(form_data, keys)
      expect(signer.received_message).to eq message
      expect(signer.received_secret_key).to eq profile.secret_key
    end
  end

  describe '.signature_message' do
    let(:form_data) { { foo: :bar, biz: :baz, wrong: :excluded } }
    subject { CybersourceSigner.signature_message(form_data, %i[biz foo]) }
    it { should eq 'biz=baz,foo=bar' }
  end
end

describe CybersourceSigner::Signer do
  describe '.signature' do
    let(:signature) { CybersourceSigner::Signer.signature(data, secret_key) }

    [
      {
        secret_key: '1234567890',
        data: 'my-data',
        expected_signature: 'wQSuKATsMj5xMgcAacRUlUULXuZfHx7dI7RH8i/HSJs='
      },
      {
        secret_key: 'fhgasfdkjbcjhaslxmfknakjflvkbasdkfjhsadkjfhsfkjh',
        data: 'gslkhqlqevlbeqsibelkvbqekjhbvjqlefbvljqkbv',
        expected_signature: 'jWe4FFfY0mPfJfKdnHiFU8DWI2fLTkJM4tk79XZuNQs='
      },
      {
        secret_key: 'FHGASFDKJBCJHASLXMFKNAKJFLVKBASDKFJHSADKJFHSFKJH',
        data: 'GSLKHQLQEVLBEQSIBELKVBQEKJHBVJQLEFBVLJQKBV',
        expected_signature: '9uUC+lPUja7zBgXnp4pddGKI6OwDM/f+ru4YDHh7cBs='
      }
    ].each do |example_data|
      context 'given some data' do
        let(:secret_key) { example_data[:secret_key] }
        let(:data) { example_data[:data] }
        let(:expected_signature) { example_data[:expected_signature] }

        it 'returns a signature' do
          expect(signature).to eq expected_signature
        end

        it 'returns a base64 encoded string' do
          expect { Base64.strict_decode64(signature) }.not_to raise_exception
        end
      end
    end
  end
end
