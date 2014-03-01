class Event < ActiveRecord::Base
  belongs_to :tag, touch: true
  delegate :color, to: :tag
end
