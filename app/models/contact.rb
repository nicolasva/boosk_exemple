class Contact < ActiveRecord::Base
  attr_accessible :firstname, :lastname, :addresses_attributes , :emails_attributes

  belongs_to :contactable, :polymorphic => true

  has_many :emails, :class_name => 'ContactEmail', :dependent => :destroy
  has_many :addresses, :as => :addressable, :dependent => :destroy

  accepts_nested_attributes_for :emails, :allow_destroy => true
  accepts_nested_attributes_for :addresses, :allow_destroy => true

  validates :firstname, :lastname, :presence => true
end
