class User < ActiveRecord::Base
  has_many :categories
  after_create :set_default_categories

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  private
  def set_default_categories
    self.categories = Category.defaults
    self.save
  end
end
