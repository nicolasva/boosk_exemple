class TaxonsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_plans
  before_filter :check_shop_authorize

  # GET /shops/1/taxonomies/1/taxons
  # GET /shops/1/taxonomies/1/taxons.json
  def index
    @taxonomy = @shop.taxonomies.find(params[:taxonomy_id])
    @taxons = @taxonomy.taxons
    respond_to do |format|
      format.html
      format.json { render json: @taxons }
    end
  end

  # GET /shops/1/taxonomies/1/taxons/1
  # GET /shops/1/taxonomies/1/taxons/1.json
  def show
    @taxon = @shop.taxonomies.find(params[:taxonomy_id]).taxons.find params[:id]

    respond_to do |format|
      format.html
      format.json { render json: @taxon.to_node.to_json }
    end
  end

  # GET /shops/1/taxonomies/1/taxons/new
  # GET /shops/1/taxonomies/1/taxons/new.json
  def new
    @taxon = @shop.taxonomies.find(params[:taxonomy_id]).taxons.build

    respond_to do |format|
      format.html     
      format.json { render json: @taxon }
    end
  end

  # GET /shops/1/taxonomies/1/taxons/1/edit
  def edit
    @taxon = @shop.taxonomies.find(params[:taxonomy_id]).taxons.find params[:id]
  end

  # POST /shops/1/taxonomies/1/taxons
  # POST /shops/1/taxonomies/1/taxons.json
  def create
    @taxon = @shop.taxonomies.find(params[:taxonomy_id]).taxons.build params[:taxon]

    respond_to do |format|
      if @taxon.save
        format.html { redirect_to shop_taxonomy_taxons_path(@shop, @taxon.taxonomy), notice: 'taxon was successfully created.' }
        format.json { render json: @taxon, status: :created, location: shop_taxonomy_taxon_url(@shop, @taxon.taxonomy, @taxon) }
      else
        format.html { render action: "new" }
        format.json { render json: @taxon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shops/1/taxonomies/1/taxons/1
  # PUT /shops/1/taxonomies/1/taxons/1.json
  def update
    @taxon = @shop.taxonomies.find(params[:taxonomy_id]).taxons.find params[:id]
    if params[:taxon]
      new_parent_id = params[:taxon][:parent_id]
      new_position = params[:taxon][:position]
    end

    if new_parent_id || new_position
      new_parent = new_parent_id.nil? ? @taxon.parent : Taxon.find(new_parent_id.to_i)
      new_position = new_position.nil? ? -1 : new_position.to_i
      @taxon.move_to_child_with_index new_parent, new_position
      new_parent.children.reload.each_with_index{ |t, index| t.update_attribute :position, index }
    end

    respond_to do |format|
      if @taxon.update_attributes(params[:taxon])
        format.html { redirect_to shop_taxonomy_taxons_path(@shop, @taxon.taxonomy), notice: 'taxon was successfully updated.' }
        format.json { render json: @taxon }
      else
        format.html { render action: "edit" }
        format.json { render json: @taxon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1/taxonomies/1/taxons/1
  # DELETE /shops/1/taxonomies/1/taxons/1.json
  def destroy
    @taxon = @shop.taxonomies.find(params[:taxonomy_id]).taxons.find params[:id]
    @taxon.destroy

    respond_to do |format|
      format.html { redirect_to shop_taxonomy_taxons_path(@shop, @taxon.taxonomy) }
      format.json { render json: @taxon }
    end
  end
end
