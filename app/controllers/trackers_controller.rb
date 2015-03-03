class TrackersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def create
    case params[:object]
    when "product"
      tracker_p = ProductTracker.find_or_initialize_by(ref: params[:ref])
      product = Product.find_by_uuid(params[:ref])
      tracker_p.shop_uid = product.shop.uuid
      tracker_p.name = product.name
      tracker_p.trackers << Tracker.new(:action => params[:actions], :host => request.remote_ip,
                                        :created_at => Time.now, :updated_at => Time.now)
      tracker_p.save
    when "shop"
      tracker_s = ShopTracker.find_or_initialize_by(:ref => params[:ref])
      tracker_s.trackers << Tracker.new(:action => params[:actions], :host => request.remote_ip,
                                        :created_at => Time.now, :updated_at => Time.now)
      tracker_s.save
    end
    render :nothing => true
  end
end
