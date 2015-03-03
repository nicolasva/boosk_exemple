class App.Promotion extends Backbone.Model
  defaults:
    name: ""
    coupon_code: ""
    selected: false
    starts_at: moment().format()
    ends_at: moment().add('M', 1).format()
    percent_discount: false
    discount_amount: 5
    description: ""
    picture: {url: "http://placehold.it/200x200"}

  valid: true

  select: (state) ->
    @set('selected', state)

  isSelected: ->
    @get('selected')

  type: ->
    if ["on", "1", "yes", true, "true"].indexOf(@get('free_shipping')) < 0 then "product_discount" else "free_shipping"

  isPercentDiscount: ->
    if ["on", "1", "yes", true, "true"].indexOf(@get('percent_discount')) < 0 then false else true

  validate: (attributes) ->
    @valid = true
    errors = []
    translate = App.i18n().toJSON()
    if attributes.discount_amount?
      if attributes.discount_amount <= 0
        errors.push "#{translate.activerecord.attributes.promotion.discount_amount.capitalize()} #{translate.activerecord.errors.messages.greater_than_or_equal_to.replace(/%{count}/, 0)}"
      else if attributes.discount_amount > 100 and attributes.percent_discount is "1"
        errors.push "#{translate.activerecord.attributes.promotion.discount_amount.capitalize()} #{translate.activerecord.errors.messages.less_than_or_equal_to.replace(/%{count}/, 100)}"
    if attributes.starts_at? and not moment(attributes.starts_at).isValid()
      errors.push "#{translate.activerecord.attributes.promotion.starts_at.capitalize()} #{translate.activerecord.errors.messages.invalid_date}"
    if attributes.ends_at?
      if not moment(attributes.ends_at).isValid()
        errors.push "#{translate.activerecord.attributes.promotion.ends_at.capitalize()} #{translate.activerecord.errors.messages.invalid_date}"
      else if attributes.starts_at? and moment(attributes.ends_at) < moment(attributes.starts_at)
        errors.push translate.activerecord.errors.messages.end_date_cannot_be_before_start_date
    if errors.length
      @valid = false
      return errors
