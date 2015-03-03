class Frontoffice::CartsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :set_cookies

  def index
    @cart = find_cart

    unless params[:country].nil? and params[:state].nil?
      @shop = Shop.find_by_uuid(params[:shop_id])
      shipping_method = ShippingMethod.match_by_buyer(params[:country],params[:state],params[:shop_id])
      @cart.compute_shipping(shipping_method)
    end

    respond_to do |format|
      format.html
      format.json { render json: @cart }
    end
  end

  def show
    @cart = find_cart

    respond_to do |format|
      format.html
      format.json { render json: @cart }
    end
  end

  def destroy
    session[:cart] = nil
    @cart = find_cart

    respond_to do |format|
      format.html
      format.js { render "/frontoffice/carts/ajax.js.coffee" }
      format.json { render json: @cart }
    end
  end
end
