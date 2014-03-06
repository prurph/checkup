require 'spec_helper'

describe Event do
  it { should belong_to(:tag).touch(true) }

  before(:each) do
    @user = User.create(email: "bob@email.com", password: "password")
    @category = Category.create(user: @user, title: "School Bus", active: true)
    @tag = Tag.create(category: @category)
    @view_start = Time.utc(2014, 03, 04, 0, 0, 0)
    @view_end = Time.utc(2014, 03, 05, 0, 0, 0)
  end

  it 'should convert time into minutes' do
    expect(Event.time_convert_to_min(3600)).to eq 60
  end

  it 'should calculate event duration where event is within the view period' do
    @event = Event.create(tag: @tag, started_at: Time.utc(2014, 03, 04, 5, 0, 0), ended_at: Time.utc(2014, 03, 04, 7, 0, 0))

    expect(Event.event_handler(@event, @view_start, @view_end)).to eq 120
  end

  it 'should calculate event duration where event starts outside the view period and ends inside the view period' do
    @event = Event.create(tag: @tag, started_at: Time.utc(2014, 03, 03, 22, 0, 0), ended_at: Time.utc(2014, 03, 04, 5, 0, 0))

    expect(Event.event_handler(@event, @view_start, @view_end)).to eq 300
  end

  it 'should calculate event duration where event starts inside the view period and ends outside the view period' do
    @event = Event.create(tag: @tag, started_at: Time.utc(2014, 03, 04, 20, 0, 0), ended_at: Time.utc(2014, 03, 05, 8, 0, 0))

    expect(Event.event_handler(@event, @view_start, @view_end)).to eq 240
  end

  it 'should calculate event duration where event starts and ends outside the period' do
    @event = Event.create(tag: @tag, started_at: Time.utc(2014, 03, 03, 15, 0, 0), ended_at: Time.utc(2014, 03, 07, 12, 0, 0))

    expect(Event.event_handler(@event, @view_start, @view_end)).to eq 1440
  end
end
