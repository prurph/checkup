require 'spec_helper'

feature 'Returning user views setup page' do
  background do
    @user = create(:user)
    sign_in_as(@user) # This lives in support/session_helpers.rb
    @work = create(:category, user: @user, title: "Work")
    @personal = create(:category, user: @user, title: "Personal")
    @family = create(:category, user: @user, title: "Family")

    @tags = []
    10.times do
      @tags.push create(:tag, category: [@work, @personal, @family].sample)
    end

    @first_work_tag     = @work.tags.first
    @first_personal_tag = @personal.tags.first
  end
  scenario 'with only active categories and only routine tags (not fancy)' do

    visit setup_path

    within('#all-categories') do
      expect(page).to     have_content "Work"
      expect(page).to     have_content "Personal"
      expect(page).to     have_content "Family"
      expect(page).to_not have_content "Goals"
    end

    within("div[data-category-id='#{@work.id}']") do
      expect(page).to have_content "Work"
      expect(page).to have_content @first_work_tag.name

      expect(page).to_not have_content "Personal"
      expect(page).to_not have_content @first_personal_tag.name
    end

    within("div[data-category-id='#{@personal.id}']") do
      expect(page).to have_content "Personal"
      expect(page).to have_content @first_personal_tag.name

      expect(page).to_not have_content "Work"
      expect(page).to_not have_content @first_work_tag.name
    end

    within('#routine-setup') do
      @tags.each do |tag|
        expect(page).to have_content tag.name
      end
    end
  end

  scenario 'with an inactive category' do
    @family.update(active: false)
    visit setup_path

    within('#all-categories') do
      expect(page).to     have_content "Work"
      expect(page).to     have_content "Personal"
      expect(page).to_not have_content "Family"
    end

    within('#routine-setup') do
      expect(page).to     have_content @first_work_tag.name
      expect(page).to     have_content @first_personal_tag.name
      expect(page).to_not have_content @family.tags.first.name
    end
  end

  scenario 'with non-routine tags' do
    @first_work_tag.update(routine: -1)
    visit setup_path

    within('#all-categories') do # Tag still shows in full-list
      expect(page).to have_content "Work"
      expect(page).to have_content @first_work_tag.name
    end

    within('#routine-setup') do # Does not show in routine list
      expect(page).to     have_content @first_personal_tag.name
      expect(page).to_not have_content @first_work_tag.name
    end
  end

  scenario 'with an inactive tag' do
    @first_work_tag.update(active: false)
    visit setup_path
    save_and_open_page

    within('#all-categories') do
      expect(page).to     have_content "Work"
      expect(page).not_to have_content @first_work_tag.name
    end

    within('#routine-setup') do
      expect(page).not_to have_content @first_work_tag.name
    end
  end
end
