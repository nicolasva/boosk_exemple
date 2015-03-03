class Frontoffice::CartItemsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :set_cookies

  def index
    @cart = find_cart

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

  def create
    product_variant = ProductVariant.find(params[:cart_item][:product_variant_id])
    @cart = find_cart
    if params[:cart_item][:quantity]
      @cart_item = @cart.add_product(product_variant, params[:cart_item][:quantity].to_i)
    else
      @cart_item = @cart.add_product(product_variant)
    end

    respond_to do |format|
      format.js { render "/frontoffice/carts/ajax.js.coffee" }
      format.json { render json: @cart_item }
    end
  end

  def update
    product_variant = ProductVariant.find(params[:cart_item][:product_variant_id])
    @cart = find_cart
    @cart_item = @cart.edit_product(product_variant, params[:cart_item][:quantity].to_i)

    respond_to do |format|
      format.html
      format.js { render "/frontoffice/carts/ajax.js.coffee" }
      format.json { render json: @cart_item }
    end
  end

  def destroy
    product_variant = ProductVariant.find(params[:id])
    @cart = find_cart
    @cart_item = @cart.remove_product(product_variant)

    respond_to do |format|
      format.html
      format.js { render "/frontoffice/carts/ajax.js.coffee" }
      format.json { render json: @cart_item }
    end
  end
end
