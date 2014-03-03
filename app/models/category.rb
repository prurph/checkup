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

  def inactivate(time=Time.new)
    self.active = false
    self.inactive_at = time
  end

  # This means calling tag.active = false also deactivates associated tags
  def active=(value, time=Time.new)
    if !value
      self.inactive_at = time
      # Update all the child tags to false
      Tag.where(category: self).update_all(active: false)
    end
    self[:active] = value
    self.save
  end
end
