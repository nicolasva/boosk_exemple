class ProductVariantsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_shop_authorize
  before_filter :check_plans

  def index
    @product_variant = ProductVariant.collapse_with_option_type

    respond_to do |format|
      format.html
      format.json { render json: @product_variant.to_json }
    end
  end

  def new
    @product = Product.find(params[:product_id])
    @product_variant = @product.product_variants.build
    @product_variant.pictures.build
    @option_types = current_user.shops.find(@product.shop).option_types.group_by_key

    respond_to do |format|
      format.html
      format.json { render json: @product_variant }
    end
  end

  def create
    @product_variant = ProductVariant.new(params[:product_variant]) unless params[:product_id].nil?
    @product_variant.product_id = params[:product_id]

    respond_to do |format|
      if @product_variant.save
        @product_variant.save_pictures(params[:pictures]) unless params[:pictures].nil?
        format.html { redirect_to [@product_variant.product.shop ,@product_variant.product] }
        format.json { render json: @product_variant.to_json(:include => [:option_types, :pictures]) }
      else
        format.html { render :new }
        format.json { render json: @product_variant.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @product_variant = ProductVariant.eager_loading.find(params[:id])
    @option_types = current_user.shops.find(@product_variant.product.shop).option_types.group_by_key

    respond_to do |format|
      format.html
    end
  end

  def update
    @product_variant = ProductVariant.eager_loading.find(params[:id])
    params[:product_variant].delete(:product_id) unless params[:product_variant][:product_id].nil?

    respond_to do |format|
      if @product_variant.update_attributes!(params[:product_variant])
        @product_variant.save_pictures(params[:pictures]) unless params[:pictures].nil?
        format.html { redirect_to [@product_variant.product.shop, @product_variant.product] }
        format.json { render json: @product_variant.to_json(:include => [:option_types, :pictures]) }
      else
        format.html { render action: "edit" }
        format.json { render json: @product_variant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product_variant = ProductVariant.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to [@product_variant.product.shop ,@product_variant.product] }
      format.json { render json: @product_variant }
    end
  end
end
