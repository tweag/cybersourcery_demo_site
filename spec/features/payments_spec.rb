require 'rails_helper'

feature 'Payments' do
  scenario 'fails to submit the transaction when the fields are not filled in', js: true do
    FactoryGirl.create :profile
    visit new_payment_path
    click_button 'Submit'
    # TODO: add a client-side validation failure message, so we have something specific to look for
    expect(page).to have_content 'New payment'
  end

  # TODO: make this run through Sorcery, instead of hitting Cybersource directly
  # Also, the only reason this passes right now is I have identical profiles set up
  # locally and on Heroku, and the profile's "return_url" points to Heroku (since I can't
  # easily get Cybersource to respond directly to a locally generated form submission)
  scenario 'successfully submits a transaction', js: true do
    FactoryGirl.create :profile
    visit new_payment_path
    fill_in 'bill_to_forename', with: 'Michael'
    fill_in 'bill_to_surname', with: 'Toppa'
    fill_in 'card_number', with: '4111111111111111'
    select '01', from: 'card_expiry_month'
    select '2015', from: 'card_expiry_year'
    fill_in 'card_cvn', with: '110'
    select 'Visa', from: 'card_type'
    fill_in 'bill_to_email', with: 'public@toppa.com'
    select 'United States', from: 'bill_to_address_country'
    fill_in 'bill_to_address_line1', with: '123 Happy St'
    fill_in 'bill_to_address_city', with: 'Havertown'
    select 'Pennsylvania', from: 'bill_to_address_state'
    fill_in 'bill_to_address_postal_code', with: '19083'
    click_button 'Submit'

    # We get a security warning running this through selenium (since we're submitting to https)
    alert = page.driver.browser.switch_to.alert
    alert.accept

    expect(page).to have_content 'Made it!'
  end

end
