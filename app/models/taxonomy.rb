class Taxonomy < ActiveRecord::Base
  attr_accessible :name

  belongs_to :shop
  has_many :taxons
  has_one :root,    :class_name => "Taxon", :conditions => { :parent_id => nil }, :dependent => :destroy

  validates :name, :presence => true

  after_save :set_root

  def set_root
    if root
      root.update_attribute(:name, name)
    else
      self.root = Taxon.create!({ :taxonomy_id => id, :name => name }, :without_protection => true)
    end
  end

  def as_json(options={})
    super(options.merge(include: [:taxons]))
  end
end
