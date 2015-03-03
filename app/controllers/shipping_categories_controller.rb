class ShippingCategoriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_shop_authorize

  # GET /shops/1/shipping_categories
  # GET /shops/1/shipping_categories.json
  def index
    @shipping_categories = @shop.shipping_categories
    respond_to do |format|
      format.html
      format.json { render json: @shipping_categories }
    end
  end

  # GET /shops/1/shipping_categories/1
  # GET /shops/shipping_categories/1.json
  def show
    @shipping_category = @shop.shipping_categories.find params[:id]

    respond_to do |format|
      format.html
      format.json { render json: @shipping_category }
    end
  end

  # GET /shops/1/shipping_categories/new
  # GET /shops/1/shipping_categories/new.json
  def new
    @shipping_category = @shop.shipping_categories.build

    respond_to do |format|
      format.html     
      format.json { render json: @shipping_category }
    end
  end

  # GET /shops/1/shipping_categories/1/edit
  def edit
    @shipping_category = @shop.shipping_categories.find params[:id]
  end

  # POST /shops/1/shipping_categories
  # POST /shops/1/shipping_categories.json
  def create
    @shipping_category = @shop.shipping_categories.build params[:shipping_category]

    respond_to do |format|
      if @shipping_category.save
        format.html { redirect_to shop_shipping_categories_path(@shipping_category.shop), notice: 'Shipping category was successfully created.' }
        format.json { render json: @shipping_category, status: :created, location: shop_shipping_category_url(@shipping_category.shop, @shipping_category) }
      else
        format.html { render action: "new" }
        format.json { render json: @shipping_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shops/1/shipping_categories/1
  # PUT /shops/1/shipping_categories/1.json
  def update
    @shipping_category = @shop.shipping_categories.find(params[:id])

    respond_to do |format|
      if @shipping_category.update_attributes(params[:shipping_category])
        format.html { redirect_to shop_shipping_categories_path(@shipping_category.shop), notice: 'Shipping category was successfully updated.' }
        format.json { render json: @shipping_category }
      else
        format.html { render action: "edit" }
        format.json { render json: @shipping_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1/shipping_categories/1
  # DELETE /shops/1/shipping_categories/1.json
  def destroy
    @shipping_category = @shop.shipping_categories.find(params[:id])
    @shipping_category.destroy

    respond_to do |format|
      format.html { redirect_to shop_shipping_categories_path(@shop) }
      format.json { render json: @shipping_category }
    end
  end

end
