require 'spec_helper'

feature 'User views setup page' do
  scenario 'with her own categories and tags' do
    user = create(:user)
    sign_in_as(user) # This lives in support/session_helpers.rb
    3.times do { create(:category, user: user) }
  end
end
