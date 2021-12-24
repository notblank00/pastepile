# frozen_string_literal: true

require 'rails_helper'

USERNAME = 'test_user'
EMAIL = 'test@example.org'
PASSWORD = 'password'

describe 'Account system', type: :feature do
  def create_user
    User.create(username: USERNAME, email: EMAIL, password: PASSWORD)
  end

  it 'allows to register a user', js: true do
    visit '/signup'
    fill_in 'Username', with: USERNAME
    fill_in 'Email', with: EMAIL
    fill_in 'Password', with: PASSWORD
    fill_in 'Confirm password', with: PASSWORD
    click_on 'Submit'
    expect(User.find_by(username: 'test_user')).not_to be_nil
    expect(page.body).to include 'test_user'
  end

  it 'does not allow to sign as nonexistent user', js: true do
    create_user
    visit 'signin'
    fill_in 'Username', with: USERNAME
    fill_in 'Password', with: PASSWORD
    click_on :commit
  end

  it 'does not allow to sign as nonexistent user', js: true do
    create_user
    visit 'signin'
    fill_in 'Username', with: USERNAME
    fill_in 'Password', with: PASSWORD
    click_on :commit
  end
end
