class Event < ActiveRecord::Base
  belongs_to :tag, touch: true
  delegate :color, to: :tag

  def self.events_time_period(events, view_start, view_end)
    events_time_structure = {}
    events_time_tag_structure = {}
    events.each do |event|
      if event.duration != 0
        tag_with_id = "#{event.tag.name}_#{event.tag.id}"
        events_time_tag_structure[tag_with_id] = [] if !events_time_tag_structure[tag_with_id].present?
        events_time_tag_structure[tag_with_id] << [event.started_at, event.ended_at, Event.event_handler(event, view_start, view_end)]
      end
    end
    events_time_tag_structure.keys.each do |tag_with_id|
      id = tag_with_id.split('_').last
      event = Event.find_by_tag_id(id)
      events_time_structure[event.tag.category.title] = {} if !events_time_structure[event.tag.category.title].present?
      events_time_structure[event.tag.category.title][event.tag.name] = events_time_tag_structure[tag_with_id]
    end
    events_time_structure
  end

  # this method will handle the SINGLE event for different duration of different day
  def self.event_handler(event, view_start, view_end)
    # find the create time, end time(which is equal to update time) of the specific events
    create_time = event.started_at
    end_time = event.ended_at
    # starting handle the event time, check if event span muliple days
    if create_time >= view_start && end_time <= view_end
      return Event.time_convert_to_min(end_time - create_time)
    elsif create_time < view_start && end_time <= view_end
      return Event.time_convert_to_min(end_time - view_start)
    elsif create_time >= view_start && end_time > view_end
      return Event.time_convert_to_min(view_end - create_time)
    else
      return Event.time_convert_to_min(view_end - view_start)
    end
  end

  # define method convert sec to min
  def self.time_convert_to_min(time)
    (time / 60).to_i
  end
end
