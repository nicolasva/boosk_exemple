class Shop < ActiveRecord::Base
  require 'rest-graph'
  require 'carmen'
  include Carmen

  before_save :slugit
  before_create :set_uuid
  after_create :create_menu, :create_customization, :create_shop_zone, :send_notif_for_invit
  after_destroy :remove_trackers_and_fb_tab

  has_and_belongs_to_many :users
  has_many :products,                                 :dependent => :destroy
  has_many :orders,                                   :dependent => :destroy
  has_many :option_types,                             :dependent => :destroy
  has_many :zones,                                    :dependent => :destroy
  has_many :tax_rates,                                :dependent => :destroy
  has_many :shipping_categories,                      :dependent => :destroy
  has_many :shipping_methods,                         :dependent => :destroy
  has_many :taxonomies,                               :dependent => :destroy
  has_one  :customization,                            :dependent => :destroy
  has_one  :contact,             :as => :contactable, :dependent => :destroy
  has_one  :product_feed,                             :dependent => :destroy
  has_many :promotions,                               :dependent => :destroy

  accepts_nested_attributes_for :option_types,   :allow_destroy => true
  accepts_nested_attributes_for :contact,        :allow_destroy => true
  accepts_nested_attributes_for :customization,  :allow_destroy => true

  attr_accessible :name, :baseline, :description, :terms, :url_website, :devise, :contact_attributes, :paypal_account, :fan_page_id, :customization_attributes
  attr_accessible :facebook_status, :mobile_status, :google_shopping_status, :google_shopping_key, :web_status, :tv_status, :address_attributes, :has_active_payement
  attr_accessible :data_product_feed_url, :facebook_page_token
  validates :name, :presence => true

  scope :open, where(:facebook_status => true)
  scope :close, where(:facebook_status => false)
  scope :eager_loading, includes({:taxonomies => [:taxons]},:orders)
  scope :by_user, lambda {|user_id|
    joins(:users).where(:users => {:id => user_id})
  }

  def taxons
    taxonomies.first.taxons.where('parent_id IS NOT NULL')
  end

  def create_menu
    taxonomies.create(name: "Menu")
  end

  def send_notif_for_invit
    user = self.users.first
    unless user.shop_key.nil?
      UserMailer.invit_step_create_shop(user, self).deliver
      user.shop_key = nil
      user.save!
    end
  end

  def create_shop_zone
    zone = Zone.new({:name  => contact.addresses.first.country})
    zone.shop = self
    zone.zone_members << ZoneMember.new({:code => Country.named(contact.addresses.first.country).alpha_2_code})
    zone.save!
  end

  def slug_url
    "https://#{self.slug}.#{BOOSKETSHOPS['frontoffice']}"
  end

  def uri(ui)
    case ui
      when "facebook"
        "https://www.facebook.com/pages/a/#{self.fan_page_id}?sk=app_#{BOOSKETSHOPS['facebook']['app_id']}"
      when "mobile"
        "#{self.slug_url}/#{ui}/#/shops/#{self.uuid}"
      end
  end

  def has_customization
    self.users.master.plan.has_customization
  end

  def as_json(options)
    hash = serializable_hash(options)
    hash.merge({'uri_facebook' => self.uri('facebook'), 'uri_mobile' => self.uri('mobile')})
  end

  private
    def slugit
      self.slug = self.name.parameterize
    end

    def set_uuid
      self.uuid = Guid.new.to_s
    end

    def remove_trackers_and_fb_tab
      ShopTracker.destroy_all(:ref => self.uuid)

      unless self.fan_page_id.nil?
        rg = RestGraph.new(:access_token => self.facebook_page_token)
        rg.delete("#{self.fan_page_id}/tabs/app_#{BOOSKETSHOPS['facebook']['app_id']}", :async => true)
      end
    end
end
