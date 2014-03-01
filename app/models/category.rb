class Category < ActiveRecord::Base
  belongs_to :user
  has_many :tags

  def inactivate(time=Time.new)
    self.active = false
    self.inactive_at = time
  end
end
