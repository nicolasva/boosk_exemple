class ProductGroupPromotionRule < PromotionRule
  has_many :promotion_rule_members, :foreign_key => "promotion_rule_id", :dependent => :destroy
  has_many :products, :through => :promotion_rule_members, :source => :item, :source_type => 'Product'

  attr_accessible :product_ids

  def as_json(options={})
    super(options.merge(methods: :product_ids))
  end
end