class ContactEmail < ActiveRecord::Base
  belongs_to :contact

  validates :email, :presence => true
end
