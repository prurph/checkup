require 'spec_helper'

describe Tag do
  it { should have_many(:events) }
  it { should belong_to(:category).touch(true) }


  it 'should reject duplicate names for active tags' do
    @category = Category.create(title: "Work")

    @active_tag = Tag.create(category: @category, name: "Foo", active: true)
    expect {Tag.create!(category: @category, name: "Foo", active: true)}.to raise_error
  end

  it 'should allow duplicate names for inactive tags' do
    @category = Category.create(title: "Work")
    @active_tag = Tag.create(category: @category, name: "Foo", active: true)
    @inactive_tag = Tag.create(category: @category, name: "Bar", active: false)

    expect {Tag.create!(category: @category, name: "Foo", active: false)}.to_not raise_error
    expect {Tag.create!(category: @category, name: "Bar", active: false)}.to_not raise_error
  end
end

