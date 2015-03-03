class ShopsController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  before_filter :check_plans
  before_filter :check_shop_authorize, except: [:index, :show, :create]
  before_filter :check_authorization, :only => [:create]
  skip_before_filter :set_cookies, :only => [:destroy]

  # GET /shops
  # GET /shops.json
  def index
    @shops = current_user.shops

    respond_to do |format|
      format.html
      format.json { render json: @shops }
    end
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
    @shop = Shop.find_by_uuid(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @shop }
    end
  end

  # GET /shops/new
  # GET /shops/new.json
  def new
    @shop = Shop.new

    respond_to do |format|
      format.html
      format.json { render json: @shop }
    end
  end

  # GET /shops/1/edit
  def edit
    @shop = Shop.find_by_uuid(params[:id])
  end

  # POST /shops
  # POST /shops.json
  def create
    @shop = Shop.new(params[:shop])
    @shop.users << current_user
    current_user.update_attribute(:shop_key, params[:shop_key]) unless params[:shop_key].nil?

    respond_to do |format|
      if @shop.save
        format.html { redirect_to @shop, notice: 'Shop was successfully created.' }
        format.json { render json: @shop, status: :created, location: @shop }
      else
        format.html { render action: "new" }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shops/1
  # PUT /shops/1.json
  def update
    @shop = Shop.find(params[:id])

    respond_to do |format|
      if @shop.update_attributes(params[:shop])
        format.html { redirect_to edit_shop_path(@shop), notice: 'Shop was successfully updated.' }
        format.json { render json: @shop }
      else
        format.html { render action: "edit" }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    @shop = current_user.shops.find_by_uuid(params[:id])
    @shop.destroy

    respond_to do |format|
      format.html { redirect_to shops_url }
      format.json { render json: @shop }
    end
  end

  private
    def check_authorization
      if current_user.shops.count >= current_user.plan.number_f_shop
        render :text => "You do not have access to this service", :status => :forbidden
      end
    end
end
