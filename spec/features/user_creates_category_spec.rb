require 'spec_helper'

feature 'User can add and view categories on Setup page', :js do
  background do
    @user = create(:user)
    @default_category = create(:category, user: @user)
    sign_in_as(@user)
    visit '/setup'
    fill_in('Category Name', with: 'School')
    click_button 'Add Category'
    save_and_open_page
  end

  scenario 'successfully views categories' do
    expect(page).to have_content 'School'
    expect(page).to_not have_content 'Muffins'
  end
end

