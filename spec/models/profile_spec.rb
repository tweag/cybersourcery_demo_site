require 'rails_helper'

describe Profile do
  subject(:profile) do
    FactoryGirl.build_stubbed :profile
  end

  it { should accept_values_for(:service, 'live', 'test') }
  it { should_not accept_values_for(:service, nil, 'foo') }

  it { should_not accept_values_for(:name, nil) }
  it { should_not accept_values_for(:profile_id, nil) }
  it { should_not accept_values_for(:access_key, nil) }
  it { should_not accept_values_for(:secret_key, nil) }
  it { should_not accept_values_for(:return_url, nil) }
  it { should_not accept_values_for(:transaction_type, nil) }

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
