require 'spec_helper'
require 'rails_helper'

feature 'the signup process' do
  scenario 'has a new user page' do
    visit new_user_url
    expect(page).to have_content "New User"
  end

  feature 'signing up a user' do
    background(:each) do
      visit new_user_url
      fill_in 'Username', with: 'jason'
      fill_in 'Password', with: '123456'
      click_on 'Create User'
    end
    scenario 'shows username on the homepage after signup' do
      expect(page).to have_content 'jason'
    end
  end

  feature 'with invalid username/password' do
    background(:each) do
      visit new_user_url
      fill_in 'Username', with: ''
      fill_in 'Password', with: '123456'
      click_on 'Create User'
    end
    scenario 're-renders signup page after failed sign up' do
      
      expect(current_url).to have_content(new_user_url)
    end
  end


end

feature 'logging in' do
  

  scenario 'shows username on the homepage after login' do
    # save_and_open_page
    expect(page).to have_content('jason')
  end

end

feature 'logging out' do
  user = FactoryBot.build(:user)
  scenario 'begins with a logged out state'

  scenario 'doesn\'t show username on the homepage after logout' do
    click_on 'Logout User'
    expect(page).to_not have_content user.username
  end


end