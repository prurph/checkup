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
      self.tags.each do |tag|
        tag[:active] = false
      end
    end
    self[:active] = value
  end
end
