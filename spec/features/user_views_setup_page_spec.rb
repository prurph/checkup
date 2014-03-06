require 'spec_helper'

feature 'Returning user views setup page' do
  background do
    @user = create(:user)
    sign_in_as(@user) # This lives in support/session_helpers.rb
    @phone = create(:category, user: @user, title: "Phone")
    @wedding = create(:category, user: @user, title: "Wedding")
    @snacks = create(:category, user: @user, title: "Snacks")

    @tags = []
    10.times do |n|
      @tags.push create(:tag, category: [@phone, @wedding, @snacks][n % 3], routine: n)
    end

    @first_phone_tag = @phone.tags.first
    @first_wedding_tag = @wedding.tags.first
  end
  scenario 'with only active categories and only routine tags (not fancy)' do
    visit setup_path

    within('#all-categories') do
      expect(page).to     have_content "Phone"
      expect(page).to     have_content "Wedding"
      expect(page).to     have_content "Snacks"
      expect(page).to_not have_content "Goals"
    end

    within("div[data-category-id='#{@phone.id}']") do
      expect(page).to have_content "Phone"
      expect(page).to have_content @first_phone_tag.name

      expect(page).to_not have_content "Wedding"
      expect(page).to_not have_content @first_wedding_tag.name
    end

    within("div[data-category-id='#{@wedding.id}']") do
      expect(page).to have_content "Wedding"
      expect(page).to have_content @first_wedding_tag.name

      expect(page).to_not have_content "Phone"
      expect(page).to_not have_content @first_phone_tag.name
    end

    within('#routine-setup') do
      @tags.each do |tag|
        expect(page).to have_content tag.name
      end
    end
  end

  scenario 'with an inactive category' do
    @snacks.update(active: false)
    visit setup_path

    within('#all-categories') do
      expect(page).to     have_content "Phone"
      expect(page).to     have_content "Wedding"
      expect(page).to_not have_content "Snacks"
    end

    within('#routine-setup') do
      expect(page).to     have_content @first_phone_tag.name
      expect(page).to     have_content @first_wedding_tag.name
      expect(page).to_not have_content @snacks.tags.first.name
    end
  end

  scenario 'with non-routine tags' do
    @first_phone_tag.update(routine: -1)
    visit setup_path

    within('#all-categories') do # Tag still shows in full-list
      expect(page).to have_content "Phone"
      expect(page).to have_content @first_phone_tag.name
    end

    within('#routine-setup') do # Does not show in routine list
      expect(page).to     have_content @first_wedding_tag.name
      expect(page).to_not have_content @first_phone_tag.name
    end
  end

  scenario 'with an inactive tag' do
    @first_phone_tag.update(active: false)
    visit setup_path

    within('#all-categories') do
      expect(page).to     have_content "Phone"
      expect(page).not_to have_content @first_phone_tag.name
    end

    within('#routine-setup') do
      expect(page).not_to have_content @first_phone_tag.name
    end
  end
end
