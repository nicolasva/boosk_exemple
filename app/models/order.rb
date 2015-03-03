class Order < ActiveRecord::Base
  attr_accessible :number, :item_total, :total, :state_id, :completed_at, :credit_total
  attr_accessible :payment_total, :payment_state, :email, :special_instructions, :paid, :shop_id, :address_id, :shipment
  belongs_to :shop
  belongs_to :state
  has_many :line_items, :dependent => :destroy
  has_one :contact, :as => :contactable, :dependent => :destroy

  before_create :set_number

  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :contact, :allow_destroy => true

  scope :not_unpaid, where("workflow_state != 'unpaid'")
  scope :complete, where('completed_at IS NOT NULL')
  scope :eager_loading, includes(:contact)

  include Workflow

  workflow do
    state :unpaid do
      event :pay, :transitions_to => :paid
    end
    state :paid do
      event :unpay, :transitions_to => :unpaid
      event :shipping, :transitions_to => :shipped
      event :deliver, :transitions_to => :delivered
      event :close, :transitions_to => :closed
      event :cancel, :transitions_to => :canceled
    end
    state :shipped do
      event :pay, :transitions_to => :paid
      event :deliver, :transitions_to => :delivered
      event :cancel, :transitions_to => :canceled
      event :close, :transitions_to => :closed
    end
    state :delivered do
      event :pay, :transitions_to => :paid
      event :shipping, :transitions_to => :shipped
      event :cancel, :transitions_to => :canceled
      event :close, :transitions_to => :closed
    end
    state :closed do 
      event :unpay, :transitions_to => :unpaid
      event :pay, :transitions_to => :paid
      event :shipping, :transitions_to => :shipped
      event :deliver, :transitions_to => :delivered
      event :cancel, :transitions_to => :canceled
    end
    state :canceled do
      event :unpay, :transitions_to => :unpaid
      event :pay, :transitions_to => :paid
      event :shipping, :transitions_to => :shipped
      event :deliver, :transitions_to => :delivered
      event :close, :transitions_to => :closed
    end
  end

  def pay
    OrderMailer.pay_for_merchant(self).deliver
    OrderMailer.pay_for_customer(self).deliver
  end

  def shipping
    OrderMailer.status_for_customer(self, "shipped").deliver
  end

  def deliver
    OrderMailer.status_for_customer(self, "delivered").deliver
  end

  def cancel
    OrderMailer.status_for_customer(self, "canceled").deliver
  end

  def change_status(status)
    case status
      when "paid"
        self.pay!
      when "shipped"
        self.shipping!
      when "delivered"
        self.deliver!
      when "canceled"
        self.cancel!
      when "closed"
        self.close!
    end
  end
  
  def add_variant_from_cart(cart)
    total = 0
    cart.items.each do |item|
      current_item = LineItem.new(:quantity => item.quantity)
      current_item.product_variant = item.product
      current_item.price   = item.product.price * item.quantity
      total += current_item.price
      self.line_items << current_item
    end
    self.total = total
  end

  def products
    line_items.map { |li| li.product_variant.product }
  end

  # For compatiblity with Calculator::PriceSack
  def amount
    line_items.map(&:amount).sum
  end

  private
    def set_number
      self.number = Guid.new.to_s
    end
end
