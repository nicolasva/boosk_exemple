module ShippingMethodsHelper

  def preferences_fields calculator, form
    calculator.preferences.keys.map { |key|
      preference_label_for(key, form) +
      preference_field_for(key, calculator.preference_type(key), form)
    }.join("").html_safe
  end

  def preference_label_for preference_key, form
    form.label "preferred_#{preference_key}",
      t(preference_key, scope: [:calculator_types, :preferences, form.object.class.model_name.i18n_key])
  end

  def preference_field_for preference_key, preference_type, form
    value = case preference_type
      when "decimal" then "0.0"
      when "integer" then "0"
      else ""
    end
    form.text_field "preferred_#{preference_key}"
  end
end