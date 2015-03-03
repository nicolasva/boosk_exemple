class Zone < ActiveRecord::Base
  belongs_to :shop, touch: true
  has_and_belongs_to_many :tax_rates
  has_many :zone_members, :dependent => :destroy
  has_many :shipping_methods, :dependent => :destroy

  attr_accessible :name, :zone_members, :zone_members_codes

  validates :name, :presence => true, :uniqueness => {:scope => :shop_id}
  validates :shop_id, :presence => true

  alias :members :zone_members

  def zone_members_codes
    members.map(&:code)
  end

  def zone_members_codes= (codes)
    members.destroy_all
    codes.each { |code| zone_members.build(code: code) unless code.blank? }
  end

  def as_json(options={})
    Carmen.reset_i18n_backend
    Carmen.i18n_backend.locale = I18n.locale
    super( options.merge(methods: :zone_members_codes, include: {zone_members: {only: :code, methods: [:country, :state, :region_type]}}) )
  end
end
