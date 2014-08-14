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

  # TODO: make these run through Sorcery, instead of hitting Cybersource directly
  # Also, the only reason this passes right now is I have identical profiles set up
  # locally and on Heroku, and the profile's "return_url" points to Heroku (since I can't
  # easily get Cybersource to respond directly to a locally generated form submission)
  context 'Form passes client side validation' do
    before do
      visit new_payment_path
      fill_in 'bill_to_forename', with: 'Michael'
      fill_in 'bill_to_surname', with: 'Toppa'
      fill_in 'card_number', with: '4111111111111111'
      select '6', from: 'payment_card_expiry_dummy_2i'
      select '2015', from: 'payment_card_expiry_dummy_1i'
      fill_in 'card_cvn', with: '110'
      fill_in 'bill_to_email', with: 'public@toppa.com'
      select 'United States', from: 'bill_to_address_country'
      fill_in 'bill_to_address_line1', with: '123 Happy St'
      fill_in 'bill_to_address_city', with: 'Havertown'
      select 'Pennsylvania', from: 'bill_to_address_state'
      fill_in 'bill_to_address_postal_code', with: '19083'
    end

    scenario 'Successfully submits a transaction', js: true do
      select 'Visa', from: 'card_type'
      click_button 'Submit'

      # We get a security warning running this through selenium (since we're submitting to https)
      alert = page.driver.browser.switch_to.alert
      alert.accept

      expect(page).to have_content 'Made it!'
    end

    scenario 'Displays an error message for the  transaction', js: true do
      select 'American Express', from: 'card_type' # this type isn't compatible with the card number
      click_button 'Submit'

      alert = page.driver.browser.switch_to.alert
      alert.accept

      expect(page).to have_content 'Invalid account number'
    end

  end
end
