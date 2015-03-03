class Action < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  validates :product_id, :uniqueness => {:scope => [:user_id, :type]}
  accepts_nested_attributes_for :user
end
