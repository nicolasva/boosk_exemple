class Tracker
  include Mongoid::Document
  include Mongoid::Timestamps

  field :action, :type => String
  field :host, :type => String

  embedded_in :product_tracker
  embedded_in :shop_tracker
  embedded_in :order_tracker

end
