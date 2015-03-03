class OrderCallbackWorker
  include Sidekiq::Worker
  include Sidekiq::Util

  sidekiq_options :queue => :OrderCallback

  def perform(order_id, status, remote_ip)
    @order = Order.find(order_id)

    unless @order.nil?
      @order.line_items.each do |line_item|
        variant =  ProductVariant.find(line_item.product_variant_id)
        variant.update_attribute(:quantity, (variant.quantity.to_i - line_item.quantity.to_i)) if @order.paid?
        tracker_p = ProductTracker.find_or_initialize_by(ref: variant.product.uuid)
        tracker_p.shop_uid = variant.product.shop.uuid
        tracker_p.name = variant.product.name 
        tracker_p.trackers << Tracker.new(:action => "order", :host => remote_ip,
                                        :created_at => Time.now, :updated_at => Time.now)
        tracker_p.save
      end

      tracker_o = OrderTracker.new(:amount => @order.total.to_f, :product_count => @order.item_total,
                                   :shop_uid => @order.shop.uuid, :ref => @order.number)
      tracker_o.trackers << Tracker.new(:action => status, :host => remote_ip,
                                        :created_at => Time.now, :updated_at => Time.now)
      tracker_o.save
    end
  end
end
