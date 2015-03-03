module CalculatorTypesHelper
  def calculator_types_array
    shippingmethods = ShippingMethod.calculators.sort_by(&:name)
     
    shippingmethods.map do |shippingmethod|
      instance = shippingmethod.new
      {
        name: shippingmethod.name,
        i18n_key: shippingmethod.model_name.i18n_key,
        preferences: instance.preferences.keys.map do |key|
          {
            name: key.to_s,
            type: instance.preference_type(key).to_s
          }
        end
      }
    end
  end
end