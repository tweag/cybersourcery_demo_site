require 'rails_helper'

feature 'Profiles' do
  scenario 'fails to creates a new profile when the fields are not filled in' do
    visit new_profile_path
    click_button 'Create Profile'
    expect(page).to have_content "Name can't be blank, Service can't be blank, Service is not included in the list, Profile can't be blank, Access key can't be blank, Secret key can't be blank, Return url can't be blank, and Transaction type can't be blank"
  end

  scenario 'successfully create a new profile' do
    visit new_profile_path

    expect {
      fill_in 'profile_name', with: 'Admissions Acceptance Fee'
      choose 'profile_service_test'
      fill_in 'profile_profile_id', with: 'acptfee'
      fill_in 'profile_access_key', with: 'afd7d26021e53ad1a48f1ec10c528ec8'
      fill_in 'profile_secret_key', with: '298e5f32e86e44ecab9c0f9c544ed2dbd42377605bd64cee85ea9d7c239babfabb664153975d49b3b6377cacf8343d282f34ba20b342482cbf892be121a3820524007662e8d54222b2ef50b2f535a2fa1556f9a257f54600bba3020ca66bf15dc327ec025ced4f23903d19435547001bd3a103b7577a4a6a998e588dbc4880bc'
      fill_in 'profile_return_url', with: 'http://tranquil-ocean-5865.herokuapp.com/responses'
      select 'sale', from: 'profile_transaction_type'
      click_button 'Create Profile'
    }.to change(Profile, :count).by(1)

    expect(page).to have_content 'Profile was successfully created'
    within 'h1' do
      expect(page).to have_content 'Admissions Acceptance Fee'
    end
    expect(page).to have_content 'Service: test'
  end

  scenario 'successfully edit a profile' do
    profile = FactoryGirl.create :profile, service: 'test'
    visit edit_profile_path(profile.id)

    choose 'profile_service_live'
    click_button 'Update Profile'

    expect(page).to have_content 'Profile was successfully updated.'
    expect(page).to have_content 'Service: live'
  end

  scenario 'successfully delete a profile', js: true do
    profile = FactoryGirl.create :profile, name: 'Destroy me'
    visit profiles_path

    within "#profile_#{profile.id}" do
      click_link 'Destroy'
    end

    alert = page.driver.browser.switch_to.alert
    alert.accept

    expect(page).to have_content 'Listing profiles'
    expect(page).to_not have_content 'Destroy me'
  end
end
