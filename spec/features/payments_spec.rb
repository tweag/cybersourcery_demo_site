require 'rails_helper'

feature 'Payments' do
  context 'Form does not pass client side validation' do
    scenario 'Fails to submit the transaction when the fields are not filled in', js: true do
      visit new_payment_path
      click_button 'Submit'

      # this is relying on HTML5 validations
      expect(page).to have_content 'New payment'
    end
  end

  context 'Form passes client side validation' do
    before do
      visit new_payment_path
      fill_in 'bill_to_forename', with: 'Michael'
      fill_in 'bill_to_surname', with: 'Toppa'
      select '6', from: 'payment_card_expiry_dummy_2i'
      select '2015', from: 'payment_card_expiry_dummy_1i'
      fill_in 'card_cvn', with: '110'
      select 'Visa', from: 'card_type'
      fill_in 'bill_to_email', with: 'public@toppa.com'
      select 'United States', from: 'bill_to_address_country'
      fill_in 'bill_to_address_line1', with: '123 Happy St'
      fill_in 'bill_to_address_city', with: 'Havertown'
      select 'Pennsylvania', from: 'bill_to_address_state'
      fill_in 'bill_to_address_postal_code', with: '19083'
    end

    scenario 'Successfully submits a transaction', js: true do
      fill_in 'card_number', with: '4111111111111111'
      click_button 'Submit'

      expect(page).to have_content 'Made it!'
    end

    scenario 'Displays an error message for the  transaction', js: true do
      fill_in 'card_number', with: '3111111111111111'
      click_button 'Submit'

      expect(page).to have_content 'Declined: One or more fields in the request contains invalid data'
    end

  end
end
