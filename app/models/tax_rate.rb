class TaxRate < ActiveRecord::Base
  has_and_belongs_to_many :zones
  belongs_to :shop, touch: true
  has_many :products
  attr_accessible :label, :rate, :zone_ids

  validates :shop_id, :label, :rate, :presence => true
  validates :rate, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}

  after_create :affect_shop_zone

  def affect_shop_zone
    zones << Shop.find(self.shop_id).zones.first
  end

  def as_json(options={})
    super( options.merge(include: :zones, methods: :zone_ids) )
  end
end
