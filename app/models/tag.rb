class Tag < ActiveRecord::Base
  belongs_to :category, touch: true
  has_many :events
  before_create :set_tag_color

  validates :name, uniqueness: { scope: [:category, :active] },
    unless: Proc.new { |category| !category.active }

  def self.handleRoutine(tag_to_be_active, tag_now_active, event_now_active, event_to_be_active)
    if event_now_active.present?
      tag_now_active.current_event_id = -1
      tag_now_active.save!
      event_now_active.duration = Event.time_convert_to_min(tag_now_active.updated_at - event_now_active.created_at)
      event_now_active.ended_at = tag_now_active.updated_at
      event_now_active.save!
    end
    unless tag_to_be_active == tag_now_active
      event_to_be_active = Event.create(tag: tag_to_be_active, started_at: Time.now)
      tag_to_be_active.current_event_id = event_to_be_active.id
      tag_to_be_active.save!
    end
    event_to_be_active
  end

  def set_tag_color
    unless self.color.present?
      self.color = self.category.color
    end
  end
end
