class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_cookies, :set_locale
  after_filter  :set_cookies, :set_access_control_headers, :set_p3p
  layout :layout

  LOCALES = ["en", "fr"]
  
  private
    def layout
      case request.path.split("/")[1]
        when "facebook"
          "facebook"
        when "mobile"
          "mobile"
        else
          "application"
      end
    end

    def set_locale
      accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
      lang = (accept_language.nil? ? '' : accept_language.scan(/^[a-z]{2}/).first)
      if lang.match /^(en|fr)$/
        I18n.locale = lang
      else
        I18n.locale = 'en'
      end
    end

    def set_cookies
      if params[:ui].nil?
        if !@shop.nil?
          cookies[:shop_id] = @shop.uuid
          cookies[:shop_devise] = @shop.devise
        elsif !params[:shop_id].nil?
          shop_id = params[:shop_id]
          s = Shop.find_by_uuid(shop_id)
          cookies[:shop_id] = s.uuid
          cookies[:shop_devise] = s.devise
        elsif !cookies[:shop_id].nil?
        elsif !current_user.nil? && !current_user.shops.nil? && !current_user.shops.empty?
          cookies[:shop_id] = current_user.shops.last.uuid
          cookies[:shop_devise] = current_user.shops.last.devise
        end
      end
    end

    def set_p3p
      response.headers['P3P'] = 'CP="CAO PSA OUR IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"'
    end

    def check_plans
      unless current_user.nil?
        if current_user.plan.nil?
          respond_to do |format|
            format.html { render text: "Access denied !", status: 403 }
            format.json { render json: {error: true, message: "Access denied !"}, status: 403 }
          end
          return false
        end
      end
    end

    def find_cart
      @cart = session[:cart] ||= Cart.new
    end

    def check_shop_authorize
      uuid = cookies[:shop_id].nil? ? params[:shop_id] : cookies[:shop_id]
      unless uuid.nil?
        unless current_user.shops.exists?(:uuid => uuid)
          render :nothing => true, :status => 403 
        else
          @shop = Shop.find_by_uuid uuid
        end
      else
        render :nothing => true, :status => 403
      end
    end

    def get_shop_from_subdomain
      @shop = Shop.find_by_slug!(request.subdomains.first)
      if params[:ui] == 'facebook'
        cookies[:front_shop_id] =     {:value => @shop.uuid,   :domain => 'facebook.com'}
        cookies[:front_shop_devise] = {:value => @shop.devise, :domain => 'facebook.com'}
      end
      cookies[:front_shop_id] = @shop.uuid
      cookies[:front_shop_devise] =  @shop.devise
    end

    def set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Credentials'] = 'true'
      headers['Access-Control-Allow-Methods'] = 'GET,OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'x-requested-with'
    end

end
