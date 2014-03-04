class Tag < ActiveRecord::Base
  belongs_to :category, touch: true
  has_many :events

  validates :name, uniqueness: { scope: [:category, :active] },
    unless: Proc.new { |category| !category.active }

  delegate :color, to: :category

  def self.handleRoutine(tag_to_be_active, tag_now_active, event_now_active, event_to_be_active)
    if tag_to_be_active == tag_now_active
      pause
    elsif event_now_active.present?
      # de-event the active tag
      tag_now_active.current_event_id = -1
      tag_now_active.save!

      # set the duration of current event, this gives the minutes of time in event duration
      # update the update time for event for handling the different day of event
      event_now_active.duration = Event.time_convert_to_min(tag_now_active.updated_at - event_now_active.created_at)
      event_now_active.updated_at = tag_now_active.updated_at
      event_now_active.save!
    else 
      event_to_be_active = Event.create(tag: tag_to_be_active)
      # active the to-be-active tag
      tag_to_be_active.current_event_id = event_to_be_active.id
      tag_to_be_active.save!
    end
    event_to_be_active
  end
end
