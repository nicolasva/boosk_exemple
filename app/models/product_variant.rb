class ProductVariant < ActiveRecord::Base
  attr_accessible :sku, :price, :weight, :height, :width, :depth, :deleted_at, :is_master, :quantity, :pictures, :shop_id, :option_type_ids, :pictures_attributes, :price_ttc
  belongs_to :product, touch: true
  has_many :line_items
  has_and_belongs_to_many :option_types
  has_many :pictures, :class_name => 'ProductVariantPicture', :dependent => :destroy
  accepts_nested_attributes_for :pictures, :allow_destroy => true

  validates :price, :quantity, :presence => true

  scope :active, where(:deleted_at => nil)
  scope :deleted, where('deleted_at IS NOT NULL')
  scope :eager_loading, includes(:option_types, :pictures)
  scope :master, where(:is_master => true)

  def in_stock?
    true
  end
  alias in_stock in_stock?

  def save_pictures(pictures_path)
    pictures_path.each do |picture_path|
      @uploader = ProductVariantPictureUploader.new
      @uploader.retrieve_from_cache!(picture_path)
      picture = File.open("#{Rails.root}/public#{@uploader.to_s}")
      self.pictures << ProductVariantPicture.create(:picture => picture) unless picture.nil?
      @uploader.remove!
    end
  end

  def self.collapse_with_option_type
    OptionType.all.group_by.collect {|option_type| {
        :key => option_type.name, 
        :value => option_type.value, 
        :product_variants => option_type.product_variants
      } unless option_type.product_variants.empty? 
    }.compact!.group_by {|t| {:type => t[:key]}}
  end

  def price_ttc
    unless self.product.tax_rate.nil?
      (self.price * (1 + self.product.tax_rate.rate.to_f / 100) * 1).round(2)
    else
      self.price
    end
  end

  def pictures
    raw_pictures = super
    raw_pictures.push ProductVariantPicture.new(is_master: true) if raw_pictures.empty?
    raw_pictures
  end
end
