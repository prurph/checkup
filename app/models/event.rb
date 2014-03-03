class Event < ActiveRecord::Base
  belongs_to :tag, touch: true
  delegate :color, to: :tag

  def self.events_time_period(events, view_start, view_end)
    events_time_structure = {}
    events_time_tag_structure = {}
    events.each do |event|
      if event.duration != 0
        events_time_tag_structure[event.tag.name] = [] if !events_time_tag_structure.present?
        events_time_tag_structure[event.tag.name] << [event.created_at, event.updated_at, Event.event_handler(event, view_start, view_end)]
      end
    end
    events_time_tag_structure.keys.each do |tag|
      events_time_structure[tag.category.title] = {} if !events_time_structure.present?
      events_time_structure[tag.category.title][tag] = events_time_tag_structure[tag]
    end
    events_time_structure
  end

  # this method will handle the SINGLE event for different duration of different day
  def self.event_handler(event, view_start, view_end)
    # find the create time, end time(which is equal to update time) of the specific event
    create_time = event.created_at
    end_time = event.updated_at
    create_time_date_format = create_time.strftime("%B %d, %Y")
    end_time_date_format = end_time.strftime("%B %d, %Y")
    view_start_date_format = view_start.strftime("%B %d, %Y")
    view_end_date_format = view_end.strftime("%B %d, %Y")

    # starting handle the event time, check if event span muliple days
    if create_time_date_format > view_start_date_format && end_time_date_format < view_end_date_format
      return Event.time_convert_to_min(end_time - create_time)
    elsif create_time_date_format < view_start_date_format && end_time_date_format < view_end_date_format
      return Event.time_convert_to_min(end_time - view_start)
    elsif create_time_date_format > view_start_date_format && end_time_date_format > view_end_date_format
      return Event.time_convert_to_min(view_end - create_time)
    else
      return Event.time_convert_to_min(view_end - view_start)
    end
  end

  # get the time value of each Category
  def self.time_each_category(events_time_structure, category)
    time = 0
    events_time_structure[category].each do |tag, array|
      array.each do |array_val|
        time += array_val[2]
      end
    end
    time
  end

  # get the time value of each tag
  def self.time_each_tag(events_time_structure, category, tag)
    time = 0
    events_time_structure[category][tag].each do |tag_key, array|
      time += array[2]
    end
    time
  end

  # define method convert sec to min
  def self.time_convert_to_min(time)
    (time / 60).to_i
  end
end
