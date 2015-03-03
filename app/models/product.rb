class Product < ActiveRecord::Base
  attr_accessible :uuid, :slug, :name, :description, :permalink, :status, :highlight ,:available_on, :deleted_at, :shop_id, :product_variants_attributes, :shipping_category_id, :taxon_ids, :shipping_method_id, :tax_rate_id, :id, :created_at, :updated_at, :position, :old_position

  has_many :product_variants, :dependent => :destroy
  has_and_belongs_to_many :taxons, :join_table => 'products_taxons'
  belongs_to :shipping_category
  belongs_to :tax_rate
  belongs_to :shop
  has_many :promotion_rule_members, :as => :item, :dependent => :destroy
  has_many :promotion_rules, :through => :promotion_rule_members
  has_many :promotions, :through => :promotion_rules

  validates :name, :shop_id, :presence => true
  #validates_format_of :permalink, :with => URI::regexp(%w(http https))
  accepts_nested_attributes_for :product_variants, :allow_destroy => true

  before_create :set_master_on_first_variant, :set_uuid, :set_position
  before_save :slugit
  after_update :change_positions
  after_destroy :remove_trackers, :change_positions

  scope :active, where(:deleted_at => nil)
  scope :deleted, where('deleted_at IS NOT NULL')
  scope :eager_loading, includes(:product_variants => [:option_types, :pictures])


  attr_accessor :old_position

  def variant_master
    self.product_variants.master.first
  end

  def has_variants
    self.product_variants.count > 1
  end

  def slug_url
    "http://#{self.shop.slug}.#{BOOSKETSHOPS['frontoffice']}/products/#{self.slug}"
  end

  def copy
    clone = self.dup :include => [
                                 {:product_variants =>
                                   [:option_types,:pictures]
                                 },:taxons],
                     :except => [:name,:uuid]
    clone.name = "#{self.name} (#{I18n.t(:copy)})"
    clone.save!
    return clone
  end

  def promotions_overlaps?(start_date, end_date)
    overlaps = promotions.ending_after(start_date)
    unless end_date.nil?
      overlaps = overlaps.starting_before(end_date)
    end
    return overlaps.count > 0
  end

  def as_json(options={})
    as_json = super(options)
    unless options[:promotionStartDate].blank?
      as_json = as_json.merge(promotions_overlaps: promotions_overlaps?(options[:promotionStartDate], options[:promotionEndDate]))
    end
    return as_json
  end

  private
    def set_position
      self.position = self.shop.products.count + 1
    end

    def change_positions
      if self.destroyed?
        Product.update_all "position=position-1", "position > #{self.position} and shop_id = #{self.shop_id}"
      elsif !self.old_position.nil? and self.position_changed?
        if self.position < self.old_position
          Product.update_all "position=position+1", "position >= #{self.position} and position <= #{self.old_position} and id != #{self.id} and shop_id = #{self.shop_id}"
        else
          Product.update_all "position=position-1", "position <= #{self.position} and position >= #{self.old_position} and id != #{self.id} and shop_id = #{self.shop_id}"
        end
      end
    end

    def set_master_on_first_variant
      if self.product_variants.any?
        self.product_variants.first.is_master = true
      end
    end

    def slugit
      self.slug = self.name.parameterize
    end

    def set_uuid
      self.uuid = Guid.new.to_s
    end

    def remove_trackers
      ProductTracker.destroy_all(:ref => self.uuid)
    end
end
