module Ogone
  class Response
    attr_accessor :response

    def initialize(response = nil)
      @response = response
    end

    def params
      @params ||= Nokogiri::XML(response.body).at_xpath("/ncresponse").attributes.inject({}) do |buffer, (name, attribute)|
        buffer.merge(name.to_sym => attribute.content)
      end
    end

    def success?
      error_code == 0
    end

    def error_code
      params[:NCERROR].to_i
    end

    def error_message
      params[:NCERRORPLUS]
    end
  end
end
