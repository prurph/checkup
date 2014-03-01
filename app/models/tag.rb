class Tag < ActiveRecord::Base
  belongs_to :category, touch: true
  has_many :events

  delegate :color, to: category.color
end
