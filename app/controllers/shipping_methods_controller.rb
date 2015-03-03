class ShippingMethodsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_shop_authorize

  # GET /shops/1/shipping_methods
  # GET /shops/1/shipping_methods.json
  def index
    @shipping_methods = @shop.shipping_methods

    respond_to do |format|
      format.html
      format.json { render json: @shipping_methods }
    end
  end

  # GET /shops/1/shipping_methods/1
  # GET /shops/shipping_methods/1.json
  def show
    @shipping_method = @shop.shipping_methods.find params[:id]

    respond_to do |format|
      format.html
      format.json { render json: @shipping_method }
    end
  end

  # GET /shops/1/shipping_methods/new
  # GET /shops/1/shipping_methods/new.json
  def new
    @shipping_method = @shop.shipping_methods.build

    respond_to do |format|
      format.html     
      format.json { render json: @shipping_method }
    end
  end

  # GET /shops/1/shipping_methods/1/edit
  def edit
    @shipping_method = @shop.shipping_methods.find params[:id]
  end

  # POST /shops/1/shipping_methods
  # POST /shops/1/shipping_methods.json
  def create
    calculator_attributes = params[:shipping_method][:calculator_attributes]
    params[:shipping_method].delete :calculator_attributes
    @shipping_method = @shop.shipping_methods.build params[:shipping_method]
    @shipping_method.calculator.attributes = calculator_attributes

    respond_to do |format|
      if @shipping_method.save
        format.html { redirect_to shop_shipping_methods_path(@shipping_method.shop), notice: 'Shipping method was successfully created.' }
        format.json { render json: @shipping_method, status: :created, location: shop_shipping_method_url(@shipping_method.shop, @shipping_method) }
      else
        format.html { render action: "new" }
        format.json { render json: @shipping_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shops/1/shipping_methods/1
  # PUT /shops/1/shipping_methods/1.json
  def update
    calculator_attributes = params[:shipping_method][:calculator_attributes]
    params[:shipping_method].delete :calculator_attributes
    @shipping_method = @shop.shipping_methods.find(params[:id])
    @shipping_method.attributes = params[:shipping_method]
    @shipping_method.calculator.attributes = calculator_attributes

    respond_to do |format|
      if @shipping_method.save
        format.html { redirect_to shop_shipping_methods_path(@shipping_method.shop), notice: 'Shipping method was successfully updated.' }
        format.json { render json: @shipping_method }
      else
        format.html { render action: "edit" }
        format.json { render json: @shipping_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1/shipping_methods/1
  # DELETE /shops/1/shipping_methods/1.json
  def destroy
    @shipping_method = @shop.shipping_methods.find(params[:id])
    @shipping_method.destroy

    respond_to do |format|
      format.html { redirect_to shop_shipping_methods_path(@shop) }
      format.json { render json: @shipping_method }
    end
  end

  # DELETE /shipping_methods/all
  # DELETE /shipping_methods/all.json
  def destroy_all
    @shipping_methods = ShippingMethod.destroy(params[:ids])

    respond_to do |format|
      format.json { render json: @shipping_methods }
    end
  end

end
