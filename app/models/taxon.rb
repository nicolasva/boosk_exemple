class Taxon < ActiveRecord::Base
  attr_accessible :name, :parent_id, :position

  has_and_belongs_to_many :products, :join_table => 'products_taxons'
  belongs_to :taxonomy

  acts_as_nested_set :dependent => :destroy, :scope => :taxonomy

  validates :name, :presence => true

  def first_level
    self.ancestors.count > 1 ? self.ancestors.second : self
  end

end
