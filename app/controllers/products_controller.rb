class ProductsController < ApplicationController
  skip_filter :set_cookies, only: :import
  skip_filter :set_locale, only: :import
  before_filter :authenticate_user!, except: :import
  before_filter :check_plans, except: :import
  before_filter :check_shop_authorize, except: :import

  # GET /products
  # GET /products.json
  def index
    params[:page] ||= 1
    params[:perPage] ||= 10
    @page = params[:page].to_i
    @item_per_page = params[:perPage].to_i
    @item_count = current_user.shops.find_by_uuid(params[:shop_id]).products.count
    @products = current_user.shops.find_by_uuid(params[:shop_id]).products.eager_loading
      .limit(@item_per_page).offset(@item_per_page*(@page-1)).order(:position)
    json_options = {:include => {:product_variants => {:include => [:option_types,:pictures]}, :shipping_category => {}}, :methods => [:taxon_ids]}
    unless params[:promotionStart].blank?
      start_date = params[:promotionStart].to_datetime
      end_date = params[:promotionEnd].blank? ? nil : params[:promotionEnd].to_datetime
      json_options = json_options.merge({promotionStartDate: start_date, promotionEndDate: end_date})
    end
    respond_to do |format|
      format.html
      format.json { render json: {
          :products => @products.as_json(json_options),
          :page => @page,
          :total => @item_count,
          :perPage => @item_per_page
        }
      }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.eager_loading.find_by_uuid(params[:id])

    respond_to do |format|
      format.html { redirect_to edit_shop_product_path(@product.shop_id, @product)}
      format.json { render json: @product.as_json(:include => {:product_variants => {:include => [:option_types,:pictures]}, :shipping_category => {}}, :methods => [:taxon_ids]) }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
    @shop = current_user.shops.find_by_uuid(params[:shop_id])
    @product.product_variants.build

    respond_to do |format|
      format.html
      format.json { render json: @product}
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find_by_uuid(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])
    @product.shop = Shop.find_by_uuid params[:shop_id]

    respond_to do |format|
      if @product.save!
        format.html { redirect_to shop_products_path(@product.shop.uuid), notice: 'Product was successfully created.' }
        format.json { render json: @product.to_json(:include => {:product_variants => {:include => [:option_types,:pictures]}})}
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.eager_loading.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to shop_products_path(@product.shop.uuid), notice: 'Product was successfully updated.' }
        format.json { render json: @product.to_json(:include => {:product_variants => {:include => [:option_types,:pictures]}})}
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /products/all
  # DELETE /products/all.json
  def destroy_all
    @products = Product.destroy(params[:ids])
    ProductTracker.destroy_all(:ref.in => @products.map{|p|p.uuid})

    respond_to do |format|
      format.json { render json: @products }
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to shop_products_path(@product.shop_id) }
      format.json { render json: @product }
    end
  end

  # POST /products/copy
  # POST /products/copy.json
  def copy
    copied_products = []

    params[:ids].each do |id| 
      product = Product.find(id)
      copied_products << product.copy unless product.nil?
    end

    respond_to do |format|
      format.json { render json: copied_products.as_json(:include => {:product_variants => {:include => [:option_types,:pictures]}}, :methods => [:taxon_ids])}
    end
  end

  # GET /shops/:shop_id/products/import?url=:feed_url
  def import
    shop = Shop.find_by_uuid params[:shop_id]
    @errors = {}
    if shop.nil?
      @errors[:general] = "Can't find shop with this UUID"
    elsif shop.product_feed
      @errors[:general] = "Product feed already queued"
    else
      @feed = shop.create_product_feed(url: params[:url])
      if @feed.valid?
        ImportProductsWorker.perform_async(@feed.id)
      else
        @errors = @feed.errors
      end
    end

    respond_to do |format|
      if defined? @feed and @feed.valid?
        format.json { render json: @feed }
        format.html { render inline: "Thanks ! Your product feed will be processed as soon as possible."}
      else
        format.json { render json: @errors, status: :unprocessable_entity }
        format.html { render inline: @errors.to_xml, status: :unprocessable_entity }
      end
    end
  end

  # POST /shops/:shop_id/products/import_by_upload
  def import_by_upload
    unless params[:file].nil?
      shop = Shop.find_by_uuid params[:shop_id]
      uploader = ImportProductCsvUploader.new
      params[:file].original_filename = shop.uuid
      uploader.store!(params[:file])
      shop.product_feed.destroy unless shop.product_feed.nil?
      @feed = shop.create_product_feed(url: "http://#{BOOSKETSHOPS['host']}#{uploader.to_s}")

      if @feed.valid?
        ImportProductsWorker.perform_async(@feed.id, 'csv')
      else
        @errors = @feed.errors
      end
    end

    respond_to do |format|
      if defined? @feed and @feed.valid?
        format.json { render json: @feed }
        format.html { render inline: "Thanks ! Your product feed will be processed as soon as possible."}
      else
        format.json { render json: @errors, status: :unprocessable_entity }
        format.html { render inline: @errors.to_xml, status: :unprocessable_entity }
      end
    end
  end

end
