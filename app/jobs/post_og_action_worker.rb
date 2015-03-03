# coding: utf-8

class PostOGActionWorker
  include Rails.application.routes.url_helpers
  include Sidekiq::Worker
  include Sidekiq::Util

  #sidekiq_options :queue => :PostToFacebook

  def perform(type, product_id, facebook_token)
    ActiveRecord::Base.verify_active_connections!

    @product = Product.find(product_id)

    if @product
      user_rg = RestGraph.new(:access_token => facebook_token)

      case type

        when "Want"
          try = 0
          begin
            user_rg.post("me/boosket_shop:want", :product => @product.slug_url, :async => true)
          rescue RestGraph::Error::InvalidAccessToken => iat
            Rails.logger.warn "[POST Want]Invalid Facebook token error (code : #{iat.error["error"]["code"]}; message: #{iat.error["error"]["message"]}; token: #{facebook_token})."
          rescue Timeout::Error
            Rails.logger.warn "[POST Want]Try nb." + try + "timed out."
            try += 1
            retry until try == 4
          end

        when "Have"
          try = 0
          begin
            user_rg.post("me/boosket_shop:have", :product => @product.slug_url, :async => true)
          rescue RestGraph::Error::InvalidAccessToken => iat
            Rails.logger.warn "[POST Have]Invalid Facebook token error (code : #{iat.error["error"]["code"]}; message: #{iat.error["error"]["message"]}; token: #{facebook_token})."
          rescue Timeout::Error
            Rails.logger.warn "[POST Have]Try nb." + try + "timed out."
            try += 1
            retry until try == 4
          end

        when "Like"
          try = 0
          begin
            user_rg.post("me/og.likes", :object => @product.slug_url, :async => true)
          rescue RestGraph::Error::InvalidAccessToken => iat
            Rails.logger.warn "[POST Like]Invalid Facebook token error (code : #{iat.error["error"]["code"]}; message: #{iat.error["error"]["message"]}; token: #{facebook_token})."
          rescue Timeout::Error
            Rails.logger.warn "[POST Like]Try nb." + try + "timed out."
            try += 1
            retry until try == 4
          end

      end

    end
  end
end
