class Frontoffice::ShopsController < ApplicationController
  caches_action :translate, :geographic_regions
  skip_before_filter :verify_authenticity_token, :set_cookies
  before_filter :decode_signed_request, :get_shop_from_subdomain, :only => :show

  def show
    id = cookies[:front_shop_id].nil? ? params[:id] : cookies[:front_shop_id]
    @preview = true unless params[:preview].nil?
    @shop = Shop.find_by_uuid(id.nil? ? params[:id] : id)
    @customization = @shop.customization
    @cart_user = find_cart

    respond_to do |format|
      format.html
      format.json { render json: @shop.to_json(:include => {:customization => {:include => [:header, :footer]}})}
    end
  end

  # GET /shops/1/terms_of_services
  # GET /facebook/shops/1/terms_of_services
  def terms_of_services
    @shop = Shop.find_by_uuid(params[:shop_id])

    render :layout => false
  end

  def translate
    params[:lang] ||= extract_locale_from_accept_language_header
    lang = params[:lang].split('-').first or params[:lang]
    I18n.backend.send(:init_translations)
    translations = I18n.backend.send(:translations)
    respond_to do |format|
      format.json { render json: translations[:"#{lang}"] }
    end
  end

  def geographic_regions
    respond_to do |format|
      format.json { render json: carmen_regions }
    end
  end

  protected
    def extract_locale_from_accept_language_header
      request.env['HTTP_ACCEPT_LANGUAGE'] ? request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first : "en"
    end

    def carmen_regions
      Rails.cache.fetch([:carmen_regions, I18n.locale], expires_in: 7.days) do
        Carmen.reset_i18n_backend
        Carmen.i18n_backend.locale = I18n.locale
        Carmen::Country.all.collect do |r|
          {
            name: r.name,
            code: r.code,
            type: r.type,
            subregions: r.subregions.collect do |s|
              {
                name: s.name,
                code: "#{r.code}|#{s.code}",
                type: s.type
              }
            end
          }
        end
      end
    end

    def base64_url_decode str
      encoded_str = str.gsub('-','+').gsub('_','/')
      encoded_str += '=' while !(encoded_str.size % 4).zero?
      Base64.decode64(encoded_str)
    end

    def decode_signed_request
      return true unless params[:signed_request]
      signed_request = params[:signed_request]
      encoded_sig, payload = signed_request.split('.')
      data = ActiveSupport::JSON.decode base64_url_decode(payload)
      shop = Shop.find_by_fan_page_id data['page']['id']
      if shop
        redirect_to "#{shop.slug_url}/#{params[:ui]}/#/shops/#{shop.uuid}"
      end
    end

end
