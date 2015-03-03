class ProductVariantPicture < ActiveRecord::Base
  attr_accessible :picture, :cached_path, :is_master
  belongs_to :product_variant, touch: true
  before_save :build_picture_from_cache, :if => "remote_picture_url.blank?"

  mount_uploader :picture, ProductVariantPictureUploader
  scope :get_master, where(:is_master => true)


  def build_picture_from_cache
    unless self.cached_path.nil? or self.cached_path.eql?('default_picture')
      uploader = ProductVariantPictureUploader.new
      uploader.retrieve_from_cache!(self.cached_path)
      picture = File.open("#{Rails.root}/public#{uploader.to_s}")
      self.picture = CarrierWave::SanitizedFile.new(picture)
    end
  end

  def picture=(val)
    if !val.is_a?(String) && valid?
      picture_will_change!
      super
    end
  end

end
