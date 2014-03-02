class Category < ActiveRecord::Base
  belongs_to :user
  has_many :tags

  # validates :color, uniqueness: { scope: :user }
  validates :title, uniqueness: { scope: [:user, :active] }

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
