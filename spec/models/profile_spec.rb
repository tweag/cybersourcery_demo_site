require 'rails_helper'

describe Profile do
  subject(:profile) do
    Profile.new(
      name: 'Admissions Acceptance Fee',
      service: 'test',
      profile_id: 'acptfee',
      access_key: 'afd7d26021e53ad1a48f1ec10c528ec8',
      secret_key: '298e5f32e86e44ecab9c0f9c544ed2dbd42377605bd64cee85ea9d7c239babfabb664153975d49b3b6377cacf8343d282f34ba20b342482cbf892be121a3820524007662e8d54222b2ef50b2f535a2fa1556f9a257f54600bba3020ca66bf15dc327ec025ced4f23903d19435547001bd3a103b7577a4a6a998e588dbc4880bc'
    )
  end

  describe 'validates_inclusion_of :service' do
    it 'disallows values for self.service other than "live" and "test"' do
      profile.service = 'foo'
      expect(profile).to_not be_valid
    end
  end

  describe '#transaction_url' do
    it 'returns the "live" mode Cybersource transaction URL' do
      profile.service = 'live'
      expect(profile.transaction_url).to eq 'https://secureacceptance.cybersource.com/silent/pay'
    end

    it 'returns the "test" mode Cybersource transaction URL' do
      profile.service = 'test'
      expect(profile.transaction_url).to eq 'https://testsecureacceptance.cybersource.com/silent/pay'
    end
  end
end
