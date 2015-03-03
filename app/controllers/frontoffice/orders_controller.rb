# -*- coding: utf-8 -*-
class Frontoffice::OrdersController < ApplicationController
  include RestGraph::RailsUtil
  skip_before_filter :verify_authenticity_token, :set_cookies, :set_locale
  protect_from_forgery :except => [:ipn_notification]

  def create
    @carts = find_cart
    total_price = 0
    item_total = 0
    @carts.items.each do |item|
      total_price += item.product.price.to_f * item.quantity.to_i
      item_total += item.quantity.to_i
    end
    unless params[:contact].nil?
      @contact = Contact.create(params[:contact])
      @contact.save!
    end
    shop = Shop.find_by_uuid(cookies[:front_shop_id])
    @order = Order.new(:shop_id => shop.id, :total => @carts.total_with_shipping, :item_total => item_total, :shipment => (@carts.shipping.nil? ? 0 :@carts.shipping))
    @order.contact = @contact unless @contact.nil?
    @carts.items.each do |item|
      @order.line_items << LineItem.new(:name => item.product.product.name,
                                        :uuid => item.product.product.uuid,
                                        :sku => item.product.sku,
                                        :quantity => item.quantity,
                                        :price_ttc => item.product.price_ttc,
                                        :price_ht => item.product.price,
                                        :tax => (item.tax.nil? ? 0 : item.tax)
                                        )
    end
    @order.save!

    shop = Shop.find_by_uuid(cookies[:front_shop_id])
    paypal_account = shop.paypal_account

    unless paypal_account.nil?
      pay_request = PaypalAdaptive::Request.new
      data = {
        "returnUrl"          => BOOSKETSHOPS['paypal']['order']['returnUrl'].gsub('%{frontoffice}', request.path.split("/")[1]).gsub('%{shop_slug}', "#{@order.shop.slug}") + "?ui=#{request.path.split("/")[1]}",
        "requestEnvelope"    => {"errorLanguage" => "fr_FR"},
        "currencyCode"       => shop.devise,
        "receiverList"       => { "receiver" => [{ "email" => paypal_account, "amount" => @order.total.to_f }]},
        "cancelUrl"          => BOOSKETSHOPS['paypal']['order']['cancelUrl'].gsub('%{frontoffice}', request.path.split("/")[1]).gsub("%{shop_slug}", "#{@order.shop.slug}"),
        "actionType"         => "PAY",
        "ipnNotificationUrl" => BOOSKETSHOPS['paypal']['order']['ipnNotificationUrl'].gsub('%{frontoffice}', request.path.split("/")[1]).gsub("%{shop_slug}", "#{@order.shop.slug}") + "?order_id=#{@order.id}&remote_ip=#{request.remote_ip}"
      }

      pay_response = pay_request.pay(data)

      respond_to do |format|
        if pay_response.success?
          format.json {render json: { :paypal_url => pay_response.approve_paypal_payment_url }}
        else
          render :nothing => true
        end
      end
    end
  end

  def payment_successfully
    shop = Shop.find_by_uuid(cookies[:front_shop_id])
    session[:cart] = nil
    redirect_to shop.uri(params[:ui]), :notice => I18n.t(:purchase, scope: [:views, :frontend, :checkout, :success])
  end

  def payment_canceled
    shop = Shop.find_by_uuid(cookies[:front_shop_id])
    redirect_to shop.uri(params[:ui])
  end

  def ipn_notification
    ipn = PaypalAdaptive::IpnNotification.new
    ipn.send_back(request.raw_post)
    if ipn.verified?
      @order = Order.find(params[:order_id])
      @order.pay!
      OrderCallbackWorker.perform_async(@order.id, "paid", params[:remote_ip])
    else
      OrderCallbackWorker.perform_async(@order.id, "unpaid", params[:remote_ip])
    end
    render nothing: true
  end


  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @order }
    end
  end
end
