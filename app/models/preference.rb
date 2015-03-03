class Preference < ActiveRecord::Base

  attr_accessible :name, :key, :value_type, :value

  validates :key, :presence => true
  validates :value_type, :presence => true

  scope :valid, where(Preference.arel_table[:key].not_eq(nil)).where(Preference.arel_table[:value_type].not_eq(nil))

  # The type conversions here should match
  # the ones in preferences::preferrable#convert_preference_value
  def value
    if self[:value_type].present?
      case self[:value_type].to_sym
      when :string, :text
        self[:value].to_s
      when :password
        self[:value].to_s
      when :decimal, :currency, :percent
        BigDecimal.new(self[:value].to_s).round(2, BigDecimal::ROUND_HALF_UP)
      when :integer
        self[:value].to_i
      when :boolean
        (self[:value].to_s =~ /^[t|1]/i) != nil
      end
    else
      self[:value]
    end
  end

  def raw_value
    self[:value]
  end

end
