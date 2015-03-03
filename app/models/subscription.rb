class Subscription < ActiveRecord::Base
  include CreditCardMethods

  FUNEL_TYPES = {:cb => 1, :coupon => 2, :without_cb => 3}

  attr_accessor :card_number, :month, :year, :verification_code, :cardholder_name, :period, :exist, :save_trial

  before_validation :format_credit_card_infos, :on => :create
  before_create :set_subscription_period

  belongs_to :user
  belongs_to :plan

  validates :user, :presence => true
  validates :plan, :presence => true

  validate :validate_credit_card_infos, :trial_period, :on => :create

  after_save :confirm_subscription
  before_save :active_trial_period

  def request
    @request ||= Ogone::Request.new
  end

  def process
    current_date = Date.today
    params = {
      alias: self.alias,
      card_number: card_number,
      comment: "Subscription to plan #{plan.name.capitalize}",
      cardholder_name: cardholder_name,
      expiration_date: "%02d%02s" %[month, year.to_s[-2..-1]],
      order_id: "sub#{self.id}-#{Time.now.to_i}",
      period_unit: :monthly,
      subscription_id: "sub#{self.id}",
      verification_code: verification_code
    }

    if period == "month"
      params = params.merge({
        period_interval: 1,
        period_moment: current_date.day,
        start_date: self.trial_period,
        end_date: current_date + 11.months,
        subscription_amount: plan.monthly_price
      })
    elsif period == "year"
      params = params.merge({
        period_interval: 12,
        period_moment: current_date.day,
        start_date: current_date,
        end_date: current_date + 11.months,
        subscription_amount: plan.yearly_price
      })
    end
    response = request.run(params)
    @errors[:base] << "Ogone response: #{response.error_message}" unless response.success?
    response.success?
  end

  def active_trial_period
    unless self.exist
      user = User.find(self.user_id)
      unless user.plan.nil?
        self.trial_period = (Date.today.beginning_of_day + 7.days)
      else
        self.trial_period = (Date.today.beginning_of_day + 1.month)
      end
    else
      self.trial_period = self.save_trial
    end
  end

  private

    def confirm_subscription
      UserMailer.confirmation_instructions(self.user).deliver
    end

    def set_subscription_period
      self.starting_on = Date.today
      self.ending_on = Date.today + 1.year
    end

    def format_credit_card_infos
      self.month = month.to_i if attribute_present?("month")
      self.year  = year.to_i if attribute_present?("year")
      self.card_number = card_number.to_s.gsub(/[^\d]/, "") if attribute_present?("card_number")
    end

    def validate_credit_card_infos
      validate_essential_attributes
      validate_card_number
      validate_verification_code
    end

    def validate_essential_attributes
      errors.add :cardholder_name, I18n.t(:blank, scope: [:activerecord, :errors, :messages]) if @cardholder_name.blank?

      if @month.to_i.zero? || @year.to_i.zero?
        errors.add :month, I18n.t(:blank, scope: [:activerecord, :errors, :messages]) if @month.to_i.zero?
        errors.add :year, I18n.t(:blank, scope: [:activerecord, :errors, :messages]) if @year.to_i.zero?
      else
        errors.add :month, I18n.t(:invalid, scope: [:activerecord, :errors, :messages]) unless valid_month?(@month)
        errors.add :base, I18n.t(:expired, scope: [:activerecord, :errors, :messages]) if card_expired?
        errors.add :year, I18n.t(:invalid, scope: [:activerecord, :errors, :messages]) unless card_expired? || valid_expiry_year?(@year)
      end
    end

    def expiry_date
      ExpiryDate.new(@month, @year)
    end

    def card_expired?
      expiry_date.expired?
    end

    def validate_card_number
      if card_number.blank?
        errors.add :card_number, I18n.t(:blank, scope: [:activerecord, :errors, :messages])
      elsif !Subscription.valid_number?(card_number)
        errors.add :card_number, I18n.t(:invalid, scope: [:activerecord, :errors, :messages])
      end
    end

    def validate_verification_code
      errors.add :verification_code, I18n.t(:blank, scope: [:activerecord, :errors, :messages]) if @verification_code.blank?
    end

  class ExpiryDate
    attr_reader :month, :year
    def initialize(month, year)
      @month = month.to_i
      @year = year.to_i
    end

    def expired? #:nodoc:
      Time.now.utc > expiration
    end

    def expiration #:nodoc:
      begin
        Time.utc(year, month, month_days, 23, 59, 59)
      rescue ArgumentError
        Time.at(0).utc
      end
    end

    private
      def month_days
        mdays = [nil,31,28,31,30,31,30,31,31,30,31,30,31]
        mdays[2] = 29 if Date.leap?(year)
        mdays[month]
      end
  end
end
