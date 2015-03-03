class ZonesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_shop_authorize

  # GET /shops/1/zones
  # GET /shops/1/zones.json
  def index
    @zones = @shop.zones

    if stale?(@shop)
      respond_to do |format|
        format.html
        format.json { render json: @zones }
      end
    end
  end

  # GET /shops/1/zones/1
  # GET /shops/zones/1.json
  def show
    @zone = @shop.zones.find params[:id]

    respond_to do |format|
      format.html
      format.json { render json: @zone }
    end
  end

  # GET /shops/1/zones/new
  # GET /shops/1/zones/new.json
  def new
    @zone = @shop.zones.build

    respond_to do |format|
      format.html
      format.json { render json: @zone }
    end
  end

  # GET /shops/1/zones/1/edit
  def edit
    @zone = @shop.zones.find params[:id]
  end

  # POST /shops/1/zones
  # POST /shops/1/zones.json
  def create
    @zone = @shop.zones.build params[:zone]

    respond_to do |format|
      if @zone.save
        format.html { redirect_to shop_zones_path(@zone.shop), notice: 'Zone was successfully created.' }
        format.json { render json: @zone, status: :created, location: shop_zone_url(@zone.shop, @zone) }
      else
        format.html { render action: "new" }
        format.json { render json: @zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shops/1/zones/1
  # PUT /shops/1/zones/1.json
  def update
    @zone = @shop.zones.find params[:id]

    respond_to do |format|
      if @zone.update_attributes(params[:zone])
        format.html { redirect_to shop_zones_path(@zone.shop), notice: 'Zone was successfully updated.' }
        format.json { render json: @zone }
      else
        format.html { render action: "edit" }
        format.json { render json: @zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1/zones/1
  # DELETE /shops/1/zones/1.json
  def destroy
    @zone = @shop.zones.find params[:id]
    @zone.destroy

    respond_to do |format|
      format.html { redirect_to shop_zones_path(@shop) }
      format.json { render json: @zone }
    end
  end

  # DELETE /zones/all
  # DELETE /zones/all.json
  def destroy_all
    @zones = Zone.destroy(params[:ids])

    respond_to do |format|
      format.json { render json: @zones }
    end
  end

end
