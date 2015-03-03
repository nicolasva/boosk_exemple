module ZonesHelper

  def grouped_options_for_regions zone
    regions_array = Rails.cache.fetch([:grouped_options_for_regions, I18n.locale], :expires_in => 7.days) do
      Carmen.country.all.map { |region|
        [region.name,
          region.subregions.map { |subregion| 
            [subregion.name, subregion.code]
          }.insert(0, [region.name, region.code])
        ]
      }
    end
    grouped_options_for_select regions_array, zone.zone_members_codes
  end
end