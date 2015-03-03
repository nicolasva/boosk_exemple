require "open-uri"
class ProductFeed < ActiveRecord::Base
  belongs_to :shop

  attr_accessible :shop_id, :url
  attr_accessor :errors_feed

  validates :shop, :url, :presence => true
  validates :url, :format => {:with => URI::regexp(%w(http https)) }

  def process_csv
    require 'csv'
    if shop
      @errors_feed = Hash.new {|hash, key| hash[key] = []}
      begin
        index_option_types = 16
        headers = ["sku","sku_master","name","description","url","category","tax","highlight","status","width","height","weight","depth","price","quantity","picture"]
        products = CSV.new(open(url), :headers => :first_row, :return_headers => false, :col_sep => ";")
        ActiveRecord::Base.transaction do
          shop.products.destroy_all
          products.each do |p|
            product = shop.products.includes(:product_variants).where("product_variants.sku=#{p['sku_master']}").try(:first) unless p['sku_master'].nil?
            if product.nil?
              product = shop.products.build
              product.name = p['name'] unless p['name'].nil?
              product.description = p['description'] unless p['description'].nil?
              product.tax_rate = shop.tax_rates.find_or_create_by_rate(label: p['tax'], rate: p['tax']) unless p['tax'].nil?
              product.taxons << shop.taxonomies.first.taxons.find_or_create_by_name(name: p['category'], parent_id: shop.taxonomies.first.root.id) unless p['category'].nil?
              product.permalink = p['url'] unless p['url'].nil?
              product.highlight = p['highlight'] unless p['highlight'].nil?
              product.status = p['status'] unless p['status'].nil?

              unless product.save
                product.errors.each { |key, message|
                  @errors_feed[product.name] = "#{message} (#{key})"
                }
              end
            end

            variant = product.product_variants.build
            variant.price = p['price'] unless p['price'].nil?
            variant.sku = p['sku'] unless p['sku'].nil?
            variant.weight = p['weight'] unless p['weight'].nil?
            variant.height = p['height'] unless p['height'].nil?
            variant.width = p['width'] unless p['width'].nil?
            variant.depth = p['depth'] unless p['depth'].nil?
            variant.quantity = p['quantity'] unless p['quantity'].nil?
            variant.is_master = true if p['sku'] == p['sku_master'] and product.variant_master.nil?

            unless variant.save
              variant.errors.each { |key, message|
                @errors_feed[product.name] = "#{message} (#{key})"
              }
            end

            index_option_types.upto(p.headers.length - 1).each do |i|
              unless p[i].strip.blank? and headers.include?(p[i].strip)
                option_type = shop.option_types.find_or_initialize_by_name_and_value(p.headers[i].strip, p[i].strip)
                if option_type.save
                  variant.option_types << option_type
                else
                  option_type.errors.each { |key, message|
                    @errors_feed[product.name] = "#{message} (#{key})"
                  }
                end
              end
            end

            unless p['picture'].nil?
              new_pic = ProductVariantPicture.new
              begin
                new_pic.remote_picture_url = p['picture']
                new_pic.is_master = true
                if new_pic.save
                  new_pic.update_column(:cached_path, p['picture'])
                  new_pic.update_column(:product_variant_id, variant.id)
                  new_pic.save
                  else
                  new_pic.errors.each { |key, message|
                    @errors_feed[product.name] = "#{message} (#{key})"
                  }
                end
              rescue OpenURI::HTTPError
                @errors_feed[product.name] = "thumbnail seems to be unavailable (404 not found)."
              rescue Timeout::Error
                @errors_feed[product.name] = "thumbnail seems to be unavailable (timed out request)."
              rescue SocketError
                @errors_feed[product.name] = "thumbnail seems to be unavailable (DNS fail)."
              end
            end
          end
        end
      rescue OpenURI::HTTPError
        @errors_feed["URL data product feed"] = "your feed seems to be unavailable (404 not found)."
      rescue Timeout::Error
        @errors_feed["URL data product feed"] = "your feed seems to be unavailable (timed out request)."
      rescue SocketError
        @errors_feed["URL data product feed"] = "your feed seems to be unavailable (DNS fail)."
      end
    end
  end

  def process
    if shop
      @errors_feed = Hash.new {|hash, key| hash[key] = []}
      count = 0
      begin
        doc = Nokogiri::XML(open(url))
        if doc.at('/products/product')
          ActiveRecord::Base.transaction do
            shop.products.destroy_all
            doc.xpath('/products/product').each do |p|
              product = shop.products.build
              product.name = p.at('name').text unless p.at('name').nil?
              product.description = p.at('description').text unless p.at('description').nil?
              product.tax_rate = shop.tax_rates.find_or_create_by_rate(label: p.at('vat').text, rate: p.at('vat').text) unless p.at('vat').nil?
              product.permalink = p.at('url').text unless p.at('url').nil?
              product.highlight = p.at('highlight').text unless p.at('highlight').nil?
              product.status = p.at('status').text unless p.at('status').nil?

              if product.save
                count += count
              else
                product.errors.each { |key, message|
                  @errors_feed[product.name] = "#{message} (#{key})"
                }
              end

              p.xpath('categories//category').each do |c|
                unless c.attr('name').blank?
                  parent_node = shop.taxonomies.first.taxons.find_by_name(c.parent.attr('name'))
                  parent_id = parent_node.nil? ? shop.taxonomies.first.root.id : parent_node.id
                  product.taxons << shop.taxonomies.first.taxons.find_or_create_by_name(name: c.attr('name'), parent_id: parent_id)
                end
              end

              p.xpath('variants/variant').each do |v|
                variant = product.product_variants.build
                variant.sku = v['sku'].blank? ? Time.now.strftime("%s") + rand(999999).to_s : v['sku']
                variant.is_master = true unless v['master'].nil?
                variant.price = v.at('price').text unless v.at('price').nil?
                variant.weight = v.at('weight').text unless v.at('weight').nil?
                variant.height = v.at('height').text unless v.at('height').nil?
                variant.width = v.at('width').text unless v.at('width').nil?
                variant.depth = v.at('depth').text unless v.at('depth').nil?
                variant.quantity = v.at('quantity').text unless v.at('quantity').nil?

                unless variant.save
                  variant.errors.each { |key, message|
                    errors[product.name] = "#{message} (#{key})"
                  }
                end

                v.xpath('option_types/option_type').each do |ot|
                  option_type = shop.option_types.find_or_initialize_by_name_and_value(ot['type'].strip, ot['value'].strip)
                  if option_type.save
                    variant.option_types << option_type
                  else
                    option_type.errors.each { |key, message|
                      errors[product.name] = "#{message} (#{key})"
                    }
                  end
                end
                v.xpath('pictures/picture').each do |picture|
                  unless picture.blank?
                    new_pic = ProductVariantPicture.new
                    begin
                      new_pic.remote_picture_url = picture.text
                      new_pic.is_master = true if picture['master']
                      if new_pic.save
                        new_pic.update_column(:cached_path, picture.text)
                        new_pic.update_column(:product_variant_id, variant.id)
                        new_pic.save
                      else
                        new_pic.errors.each { |key, message|
                          errors[product.name] = "#{message} (#{key})"
                        }
                      end
                    rescue OpenURI::HTTPError
                      @errors_feed[product.name] = "thumbnail seems to be unavailable (404 not found)."
                    rescue Timeout::Error
                      @errors_feed[product.name] = "thumbnail seems to be unavailable (timed out request)."
                    rescue SocketError
                      @errors_feed[product.name] = "thumbnail seems to be unavailable (DNS fail)."
                    end
                  end
                end
              end
            end
          end
        else
          @errors_feed["XML file format"] = "your data products feed must be according to the XML File Specifications of Boosket."
        end
      rescue OpenURI::HTTPError
        @errors_feed["URL data product feed"] = "your feed seems to be unavailable (404 not found)."
      rescue Timeout::Error
        @errors_feed["URL data product feed"] = "your feed seems to be unavailable (timed out request)."
      rescue SocketError
        @errors_feed["URL data product feed"] = "your feed seems to be unavailable (DNS fail)."
      end
    end
  end

end
