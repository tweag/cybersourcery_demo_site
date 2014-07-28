require 'rails_helper'

feature 'Profiles' do
  scenario 'opens the page to create a Profile' do
    visit new_profile_path
    expect(page).to have_content 'New profile'
  end
end
