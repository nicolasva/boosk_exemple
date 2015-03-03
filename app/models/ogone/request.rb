module Ogone
  class Request

    ATTRIBUTES = {
      alias:                "ALIAS", 
      amount:               "AMOUNT",
      card_number:          "CARDNO",
      comment:              ["COM", "SUB_COM"],
      currency:             "CURRENCY",
      cardholder_name:        "CN",
      eci:                  "ECI",
      end_date:             "SUB_ENDDATE",
      expiration_date:      "ED",
      operation:            "OPERATION",
      order_id:             ["ORDERID", "SUB_ORDERID"],
      password:             "PSWD",
      period_unit:          "SUB_PERIOD_UNIT",
      period_interval:      "SUB_PERIOD_NUMBER",
      period_moment:        "SUB_PERIOD_MOMENT",
      pspid:                "PSPID",
      start_date:           "SUB_STARTDATE",
      status:               "SUB_STATUS",
      subscription_amount:  "SUB_AMOUNT",
      subscription_id:      "SUBSCRIPTION_ID",
      user_id:              "USERID",
      verification_code:    "CVC"
    }

    PERIOD = {
      daily: "d",
      weekly: "ww",
      monthly: "m"
    }

    def run(params = {})
      params = prepare_params(params)
      response = post(params)
      Ogone::Response.new(response)
    end

    def prepare_params(params)
      normalize_params default_params.merge(params)
    end

    def default_params
      {
        amount: 0,
        currency: "EUR",
        eci: 9,
        operation: "RES",
        password: OGONE["password"],
        pspid: OGONE["PSPID"],
        status: "1",
        user_id: OGONE["userID"]
      }
    end

    def normalize_params(params)
      params.inject({}) do |buffer, (name, value)|
        attr_names = [ATTRIBUTES[name.to_sym]].flatten.compact
        attr_names << name if attr_names.empty?

        attr_names.each do |attr_name|
          buffer[attr_name.to_sym] = respond_to?("build_#{name}") ? send("build_#{name}", value) : value
        end

        buffer
      end
    end

    def post(params = {})
      request.form_data = params
      client.request(request)
    end

    def request
      @request ||= Net::HTTP::Post.new(uri.request_uri)
    end

    def uri
      @uri ||= URI.parse(OGONE["gateway_url"])
    end

    def client
      @client ||= begin
        Net::HTTP.new(uri.host, uri.port).tap do |http|
          http.use_ssl = true
        end
      end
    end

    def build_subscription_amount(value)
      (value*100).to_i
    end

    def build_period_unit(value)
      PERIOD.fetch(value.to_sym, value) if value
    end

    def build_start_date(value)
      value.respond_to?(:strftime) ? value.strftime("%Y-%m-%d") : value
    end

    def build_end_date(value)
      value.respond_to?(:strftime) ? value.strftime("%Y-%m-%d") : value
    end
  end
end
