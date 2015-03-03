class ZoneMember < ActiveRecord::Base
  belongs_to :zone

  attr_accessible :zone, :zone_id, :code

  def region_type
    if carmen_state.nil?
      "country"
    else
      carmen_state.type
    end
  end

  def country
    carmen_country.name
  end

  def state
    c = carmen_state
    carmen_state.name unless c.nil?
  end

  private
    def carmen_country
      unless code.blank? || Carmen::Country.coded(code.split('|', 2)[0]).nil?
        Carmen::Country.coded(code.split('|', 2)[0])
      end
    end

    def carmen_state
      c = carmen_country
      unless self.code.blank? || c.nil?  || c.subregions.empty? || c.subregions.coded(self.code.split('|', 2)[1]).nil?
        c.subregions.coded(self.code.split('|', 2)[1])
      end
    end
end
