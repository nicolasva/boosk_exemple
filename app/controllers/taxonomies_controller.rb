class TaxonomiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_shop_authorize

  # GET /shops/1/taxonomies
  # GET /shops/1/taxonomies.json
  def index
    @taxonomies = @shop.taxonomies

    respond_to do |format|
      format.html
      format.json { render json: @taxonomies.to_json(:include => :taxons) }
    end
  end

  # GET /shops/1/taxonomies/1
  # GET /shops/taxonomies/1.json
  def show
    @taxonomy = @shop.taxonomies.find params[:id]

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @taxonomy }
    end
  end

  # GET /shops/1/taxonomies/new
  # GET /shops/1/taxonomies/new.json
  def new
    @taxonomy = @shop.taxonomies.build

    respond_to do |format|
      format.html     
      format.json { render json: @taxonomy }
    end
  end

  # GET /shops/1/taxonomies/1/edit
  def edit
    @taxonomy = @shop.taxonomies.find params[:id]
  end

  # POST /shops/1/taxonomies
  # POST /shops/1/taxonomies.json
  def create
    @taxonomy = @shop.taxonomies.build params[:taxonomy]

    respond_to do |format|
      if @taxonomy.save
        format.html { redirect_to shop_taxonomies_path(@taxonomy.shop), notice: 'taxonomy was successfully created.' }
        format.json { render json: @taxonomy, status: :created, location: shop_taxonomy_url(@taxonomy.shop, @taxonomy) }
      else
        format.html { render action: "new" }
        format.json { render json: @taxonomy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shops/1/taxonomies/1
  # PUT /shops/1/taxonomies/1.json
  def update
    @taxonomy = @shop.taxonomies.find params[:id]

    respond_to do |format|
      if @taxonomy.update_attributes(params[:taxonomy])
        format.html { redirect_to shop_taxonomies_path(@taxonomy.shop), notice: 'taxonomy was successfully updated.' }
        format.json { render json: @taxonomy }
      else
        format.html { render action: "edit" }
        format.json { render json: @taxonomy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1/taxonomies/1
  # DELETE /shops/1/taxonomies/1.json
  def destroy
    @taxonomy = @shop.taxonomies.find params[:id]
    @taxonomy.destroy

    respond_to do |format|
      format.html { redirect_to shop_taxonomies_path(@shop) }
      format.json { render json: @taxonomy }
    end
  end
end
