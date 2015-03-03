# coding: utf-8

class ImportProductsWorker
  include Sidekiq::Worker
  include Sidekiq::Util

  sidekiq_options :queue => :ImportProducts

  def perform(product_feed_id,format="xml")
    ActiveRecord::Base.verify_active_connections!
    feed = ProductFeed.find(product_feed_id)
    if format == "xml"
      feed.process
    elsif format == "csv"
      feed.process_csv
    end
    ShopMailer.results_import(feed).deliver
    feed.destroy
  end

end
