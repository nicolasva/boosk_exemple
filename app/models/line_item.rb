class LineItem < ActiveRecord::Base
  attr_accessible :quantity, :price_ttc, :price_ht, :name, :sku, :tax, :uuid
  belongs_to :order

  validates :quantity, :price_ttc,:price_ht,:tax,:sku,:name,:uuid, :presence => true
  validates :quantity, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :message => 'must be int' }
  validates :price_ht,:price_ttc, :numericality => {:greater_than_or_equal_to => 0}

  scope :by_taxon, lambda {|shop_id,taxon_id|
    includes(:product_variant => [:product => :taxons], :order => [:shop]).
    where(['orders.shop_id = ? AND taxons.id = ?',shop_id,taxon_id])
  }

  def increment_quantity
    self.quantity += 1
  end

  def decrement_quantity
    self.quantity -= 1 unless self.quantity == 0
  end

  def amount
    self.price_ttc * self.quantity
  end
  alias total amount

end
