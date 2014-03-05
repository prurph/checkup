class Category < ActiveRecord::Base
  belongs_to :user
  has_many :tags

  # Color validation off until we introduce functionality to assign it on create
  # validates :color, uniqueness: { scope: [:user, :active] },
  #   unless: Proc.new { |category| !category.active }

  # Need the proc so that you can have an arbitraty number of non-unique
  # categories for the same user, provided no more than one is active
  validates :title, uniqueness: { scope: [:user, :active] },
    unless: Proc.new { |category| !category.active }

  def deactivate(time=Time.new)
    self.active = false
    self.inactive_at = time
    self.color = "127,140,141"
    Tag.where(category: self).update_all(active: false)
    self.save
  end
end
