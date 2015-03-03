class Customization < ActiveRecord::Base
  attr_accessible :background_color_shop, :background_color_product_list, :background_color_product_thumb, 
                  :background_color_sidebar, :background_color_sidebar_item, :baseline_color, :border_color, :color_text, :color_link,
                  :color_text_product, :color_link_product, :products_per_page, :products_grid, :fan_access, :search_engine,
                  :logo, :header_attributes, :footer_attributes, :shutter, :teaser, :remove_shutter, :remove_teaser, :remove_logo,
                  :color_text_menu, :color_text_menu_hover
  belongs_to :shop, touch: true
  has_one :header, :dependent => :destroy
  has_one :footer, :dependent => :destroy

  accepts_nested_attributes_for :header, :footer

  validates :shop, :presence => true
  validates :products_per_page, :numericality => { :only_integer => true, :greater_than_or_equal_to => 3 }

	mount_uploader :logo, LogoUploader
	mount_uploader :shutter, ShutterUploader
	mount_uploader :teaser, TeaserUploader

  after_create :create_header
  after_create :create_footer

  def upload(attribute, path, uploader)
    if path && path.is_a?(String)
      uploader.retrieve_from_cache!(path)
      picture = File.open("#{Rails.root}/public#{uploader.to_s}")
      self.send(attribute, picture) unless picture.nil?
      uploader.remove!
    end
  end

  def as_json(options={})
    super(options.merge(include: [{:header => {:only => [:id, :offset, :picture]}}, {:footer => {:only => [:id, :offset, :picture]}}]))
  end
end
