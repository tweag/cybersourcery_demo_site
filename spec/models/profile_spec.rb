require 'rails_helper'

describe Profile do
  subject(:profile) do
    FactoryGirl.build_stubbed :profile
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
