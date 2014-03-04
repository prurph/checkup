require 'spec_helper'

describe Event do
  it { should belong_to(:tag).touch(true) }

  before(:each) do
    @user = User.new(email: "bob@email.com", password: "password")
    @category = Category.new(user: @user, title: "Personal", active: true)
    @event = Event.new
  end

  it 'should convert time into minutes' do
    expect(Event.time_convert_to_min(3600)).to eq 60
  end

  it ''
    create_time = event.created_at
    end_time = event.updated_at
    create_time_date_format = create_time.strftime("%B %d, %Y")
    end_time_date_format = end_time.strftime("%B %d, %Y")
    view_start_date_format = view_start.strftime("%B %d, %Y")
    view_end_date_format = view_end.strftime("%B %d, %Y")


end
