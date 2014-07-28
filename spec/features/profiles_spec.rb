require 'rails_helper'

feature 'Profiles' do
  scenario 'fails to creates a new profile when the fields are not filled in' do
    visit new_profile_path
    click_button 'Create Profile'
    expect(page).to have_content 'Please review the problems below:'
  end

  scenario 'successfully creates a new profile' do
    visit new_profile_path
    fill_in 'profile_name', with: 'Admissions Acceptance Fee'
    fill_in 'profile_service', with: 'test'
    fill_in 'profile_profile_id', with: 'acptfee'
    fill_in 'profile_access_key', with: 'afd7d26021e53ad1a48f1ec10c528ec8'
    fill_in 'profile_secret_key', with: '298e5f32e86e44ecab9c0f9c544ed2dbd42377605bd64cee85ea9d7c239babfabb664153975d49b3b6377cacf8343d282f34ba20b342482cbf892be121a3820524007662e8d54222b2ef50b2f535a2fa1556f9a257f54600bba3020ca66bf15dc327ec025ced4f23903d19435547001bd3a103b7577a4a6a998e588dbc4880bc'
    click_button 'Create Profile'
    expect(page).to have_content 'Profile was successfully created'
  end
end
