require 'rails_helper'

describe PaymentsHelper do
  describe '#countries' do
    it 'returns a hash of countries' do
      countries = helper.countries
      expect(countries.size).to eq 249
      expect(countries.any? { |k,v| k == 'United States' && v == 'US' }).to be true
    end
  end

  describe '#us_states' do
    it 'returns a hash of US states' do
      states = helper.us_states
      expect(states.size).to eq 50
      expect(states.any? { |k,v| k == 'Rhode Island' && v == 'RI' }).to be true
    end
  end

  describe '#card_types' do
    it 'returns a hash of accepted card types' do
      card_types = helper.card_types
      expect(card_types.size).to eq 4
      expect(card_types.any? { |k,v| k == 'American Express' && v == '003' }).to be true
    end
  end

  describe '#card_expiry_months' do
    it 'returns a hash of numeric months' do
      months = helper.card_expiry_months
      expect(months.size).to eq 13
      expect(months.first).to eq ['Month', '']
      expect(months.any? { |k,v| k == '06' && v == '06' }).to be true
    end
  end

  describe '#card_expiry_years' do
    it 'returns a hash of 20 upcoming years' do
      years = helper.card_expiry_years('2014-06-07'.to_time)
      expect(years.size).to eq 21
      expect(years.first).to eq ['Year', '']
      expect(years.any? { |k,v| k == 2015 && v == 2015 }).to be true
    end
  end
end
