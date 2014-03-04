require 'spec_helper'

describe Category do
  it { should have_many(:tags) }
  it { should belong_to(:user) }

  it 'should require a user when creating a new category' do
    @no_user_category = Category.create(title: "Home", active: true)

    expect {Category.create!(title: "Home", active: true)}.to raise_error
  end

  it 'should reject duplicate names for active categories' do
    @user1 = User.create(email: "erin@example.com", password: "password")
    @active_category = Category.create(user: @user, title: "School", active: true)

    expect {Category.create!(user: @user, title: "School", active: true)}.to raise_error
  end
end
