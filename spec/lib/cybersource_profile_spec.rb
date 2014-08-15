require 'rails_helper'

describe CybersourceProfile do
  let(:cybersource_profiles) do
    { 'pwksgem' =>
      {
        'name' => 'PromptWorks Gem',
        'service' => 'test',
        'access_key' => '839d4d3b1cef3e04bd2981997714803b',
        'secret_key' => 'a88c7ea074fb4dea97fe33b2442ed1bed132018e773a4097848039772208de3ddd39b11f74414e709263d76e82fcc9bbef51de4852a643cabd668ba981ff3b137d5b150a352c41c3bd59edcb3ccd11eed06139676d7e44e5ba60a3b44a0a2541236bc5194db4474abba15c991d9bee0a3bc767a3b87d434789cd310da6e3a19c',
        'success_url' => 'http://tranquil-ocean-5865.herokuapp.com/responses',
        'transaction_type' => 'sale'
      }
    }
  end

  describe '#initialize' do
    it 'sets the attributes when they are valid' do
      profile = CybersourceProfile.new('pwksgem', cybersource_profiles)
      expect(profile.profile_id).to eq 'pwksgem'
      expect(profile.name).to eq 'PromptWorks Gem'
      expect(profile.service).to eq 'test'
      expect(profile.access_key).to eq '839d4d3b1cef3e04bd2981997714803b'
      expect(profile.secret_key).to eq 'a88c7ea074fb4dea97fe33b2442ed1bed132018e773a4097848039772208de3ddd39b11f74414e709263d76e82fcc9bbef51de4852a643cabd668ba981ff3b137d5b150a352c41c3bd59edcb3ccd11eed06139676d7e44e5ba60a3b44a0a2541236bc5194db4474abba15c991d9bee0a3bc767a3b87d434789cd310da6e3a19c'
      expect(profile.success_url).to eq 'http://tranquil-ocean-5865.herokuapp.com/responses'
      expect(profile.transaction_type).to eq 'sale'
    end

    it 'raises an exception if the "service" value is not "live" or "test"' do
      cybersource_profiles['pwksgem']['service'] = 'foo'
      expect { CybersourceProfile.new('pwksgem',cybersource_profiles) }.to raise_exception
    end

    it 'raises an exception if any setting is missing' do
      cybersource_profiles['pwksgem']['access_key'] = nil
      expect { CybersourceProfile.new('pwksgem', cybersource_profiles) }.to raise_exception
    end
  end

  describe '#transaction_url' do
    it 'returns the "test" mode Cybersource transaction URL' do
      profile = CybersourceProfile.new('pwksgem', cybersource_profiles)
      expect(profile.transaction_url).to eq 'http://localhost:2134/silent/pay'
    end

    it 'returns the "live" mode Cybersource transaction URL' do
      cybersource_profiles['pwksgem']['service'] = 'live'
      profile = CybersourceProfile.new('pwksgem', cybersource_profiles)
      expect(profile.transaction_url).to eq 'https://secureacceptance.cybersource.com/silent/pay'
    end
  end
end
