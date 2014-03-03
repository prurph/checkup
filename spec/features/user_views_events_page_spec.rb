require 'spec_helper'

feature 'User views Events page' do
  background do
    @user = create(:user)
    sign_in_as(@user)
    @school = create(:category, user: @user, title: "School")
    @home = create(:category, user: @user, title: "Home")
    @exercise = create(:category, user: @user, title: "Exercise")

    @tags = []
    3.times do |n|
      @tags.push create(:tag, category: [@school, @home, @exercise][n % 3], routine: n)
    end

    @first_school_tag = @school.tags.first
    @first_home_tag = @home.tags.first
    @first_exercise_tag = @exercise.tags.first

    @events = []
    8.times do |n|
        @events.push create(:event, tag: @tags.sample)
    end

    @first_school_event = @first_school_tag.events.first
    @first_home_event = @first_home_tag.events.first
    @first_exercise_event = @first_exercise_tag.events.first

    visit '/events'
  end


  scenario 'page has categories' do
    expect(page).to have_content "School"
    expect(page).to have_content "Home"
    expect(page).to have_content "Exercise"
    expect(page).to_not have_content "Work"
  end

  scenario 'page has categories with tags' do
    expect(page).to have_content @first_school_tag.name
    expect(page).to have_content @first_home_tag.name
    expect(page).to have_content @first_exercise_tag.name
  end


  scenario 'page has categories with tags and events' do
    expect(@first_school_event.duration).should be_between(300, 28800)
    expect(@first_home_event.duration).should be_between(300, 28800)
    expect(@first_exercise_event.duration).should be_between(300, 28800)
  end

end
