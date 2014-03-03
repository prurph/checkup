class Tag < ActiveRecord::Base
  belongs_to :category, touch: true
  has_many :events

  validates :name, uniqueness: { scope: [:category, :active] }

  delegate :color, to: :category
end
