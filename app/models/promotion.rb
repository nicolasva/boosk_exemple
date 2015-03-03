class Promotion < ActiveRecord::Base
  belongs_to :shop
  has_many :promotion_rules, :dependent => :destroy

  mount_uploader :picture, PromotionPictureUploader

  attr_accessible :name, :coupon_code, :free_shipping, :percent_discount, :discount_amount
  attr_accessible :starts_at, :ends_at, :description, :picture, :picture_cache
  attr_accessible :promotion_rules_attributes

  accepts_nested_attributes_for :promotion_rules

  scope :free_shipping, where(:free_shipping => true)
  scope :product_discount, where(:free_shipping => false)

  alias_method :rules, :promotion_rules

  validates :name, :starts_at, :presence => true
  validates :discount_amount, :presence => true, :unless => :free_shipping?
  validates :discount_amount, :numericality => {:greater_than => 0}, :unless => :free_shipping?, :allow_nil => true
  validates :discount_amount, :numericality => {:greater_than => 0, :less_than_or_equal_to => 100}, :if => lambda { |p| !p.free_shipping? && p.percent_discount? }, :allow_nil => true
  validates :free_shipping, :percent_discount, :inclusion => { :in => [true, false] }
  validate :promotion_dates_validation

  def promotion_dates_validation
    if (starts_at.present? and (DateTime.parse(starts_at.to_s) rescue ArgumentError) == ArgumentError)
      errors.add :starts_at, I18n.t(:invalid_date, scope: [:activerecord, :errors, :messages])
    end
    if ends_at.present?
      if ((DateTime.parse(ends_at.to_s) rescue ArgumentError) == ArgumentError)
        errors.add :ends_at, I18n.t(:invalid_date, scope: [:activerecord, :errors, :messages])
      elsif starts_at.present? and ends_at < starts_at
        errors.add :ends_at, I18n.t(:cannot_be_before_start_date, scope: [:activerecord, :errors, :messages])
      end
    end
  end

  def as_json(options={})
    super(options).merge(promotion_rules: promotion_rules.as_json)
  end

  def self.starting_before(date)
    where("starts_at < ?", date)
  end

  def self.ending_after(date)
    t = Promotion.arel_table
    where(t[:ends_at].gt(date).or(t[:ends_at].eq(nil)))
  end

  def self.current
    now = Time.zone.now
    starting_before(now).ending_after(now)
  end

end