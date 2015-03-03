class App.TaxRate extends Backbone.Model
  defaults:
    label: ""
    rate: ""
    zone_ids: []

  url: ->
    base = "/shops/#{App.current_shop}/tax_rates"
    return base  if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

  validate: (attributes) ->
    errors = []
    translate = App.i18n().toJSON()
    if !(/\S/.test(attributes.label))
      errors.push "#{translate.activerecord.attributes.tax_rate.label.capitalize()} #{translate.activerecord.errors.messages.blank}"
    if !(/\S/.test(attributes.rate))
      errors.push "#{translate.activerecord.attributes.tax_rate.rate.capitalize()} #{translate.activerecord.errors.messages.blank}"
    else if isNaN(attributes.rate)
      errors.push "#{translate.activerecord.attributes.tax_rate.rate.capitalize()} #{translate.activerecord.errors.messages.not_a_number}"
    else if attributes.rate < 0
      errors.push "#{translate.activerecord.attributes.tax_rate.rate.capitalize()} #{translate.activerecord.errors.messages.greater_than_or_equal_to.replace(/%{count}/, 0)}"
    else if attributes.rate > 100
      errors.push "#{translate.activerecord.attributes.tax_rate.rate.capitalize()} #{translate.activerecord.errors.messages.less_than_or_equal_to.replace(/%{count}/, 100)}"
    return errors if errors.length