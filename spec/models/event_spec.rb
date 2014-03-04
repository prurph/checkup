require 'spec_helper'

describe Event do
  it { should belong_to(:tag).touch(true) }

  before(:each) do
    @user = User.new(email: "bob@email.com", password: "password")
    @category = Category.new(user: @user, title: "Personal", active: true)
    @tag = Tag.new(category: @category)
  end

  it 'should convert time into minutes' do
    expect(Event.time_convert_to_min(3600)).to eq 60
  end
end
