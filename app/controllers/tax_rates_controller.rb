class TaxRatesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_shop_authorize

  # GET /shops/1/tax_rates
  # GET /shops/1/tax_rates.json
  def index
    @tax_rates = @shop.tax_rates

    if stale?(@shop)
      respond_to do |format|
        format.html
        format.json { render json: @tax_rates }
      end
    end
  end

  # GET /shops/1/tax_rates/1
  # GET /shops/tax_rates/1.json
  def show
    @tax_rates = @shop.tax_rates.find params[:id]

    respond_to do |format|
      format.html
      format.json { render json: @tax_rate}
    end
  end

  # GET /shops/1/tax_rates/new
  # GET /shops/1/tax_rates/new.json
  def new
    @tax_rate = @shop.tax_rates.build
    @zones = @shop.zones ||=[]

    if stale?(@shop)
      respond_to do |format|
        format.html
        format.json { render json: @tax_rate, zones: @zones }
      end
    end
  end

  # GET /shops/1/tax_rates/1/edit
  def edit
    @tax_rate = @shop.tax_rates.find params[:id]
    @zones = @shop.zones ||=[]
    @zones_select = @tax_rate.zones ||=[]

    if stale?(@shop)
      respond_to do |format|
        format.html
        format.json { render json: @tax_rate, zones: @zones.to_json, zones_select: @zones_select }
      end
    end
  end

  # POST /shops/1/tax_rates
  # POST /shops/1/tax_rates.json
  def create
    @tax_rate = @shop.tax_rates.build params[:tax_rate]

    respond_to do |format|
      if @tax_rate.save
        format.html { redirect_to shop_tax_rates_path(@tax_rate.shop), notice: 'Tax was successfully created.' }
        format.json { render json: @tax_rate, status: :created, location: shop_tax_rate_url(@tax_rate.shop, @tax_rate) }
      else
        format.html { render action: "new" }
        format.json { render json: @tax_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shops/1/tax_rates/1
  # PUT /shops/1/tax_rates/1.json
  def update
    @tax_rate = @shop.tax_rates.find params[:id]

    respond_to do |format|
      if @tax_rate.update_attributes(params[:tax_rate])
        format.html { redirect_to shop_tax_rates_path(@tax_rate.shop), notice: 'Tax was successfully updated.' }
        format.json { render json: @tax_rate }
      else
        format.html { render action: "edit" }
        format.json { render json: @tax_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1/tax_rates/1
  # DELETE /shops/1/tax_rates/1.json
  def destroy
    @tax_rate = @shop.tax_rates.find params[:id]
    @tax_rate.destroy

    respond_to do |format|
      format.html { redirect_to shop_tax_rates_path(@shop) }
      format.json { render json: @tax_rate }
    end
  end

  # DELETE /shops/1/tax_rates/all
  # DELETE /shops/1/tax_rates/all.json
  def destroy_all
    @tax_rates = TaxRate.destroy(params[:ids])

    respond_to do |format|
      format.json { render json: @tax_rates }
    end
  end
end
