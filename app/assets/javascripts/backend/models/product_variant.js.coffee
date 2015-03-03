class App.ProductVariant extends Backbone.Model
  url: ->
    unless @attributes.product_variant == undefined
      product_id = @attributes.product_variant.product_id
    else
      product_id = @attributes.product_id
    base = "/shops/#{App.current_shop}/products/#{product_id}/product_variants"
    return base  if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

  validate: (attributes, translate) ->
    @errors ||= []
    if attributes.price != undefined
      if isNaN(attributes.price) == true
        @errors.push "Price must be number"
      if attributes.price < 0
        @errors.push "Price must not be negativ"
    if attributes.quantity != undefined
      if parseInt(attributes.quantity) == NaN
        @errors.push translate.views.product.error.price_must_be_number
      if attributes.quantity < 0
        @errors.push translate.views.product.error.price_must_be_positiv

    return true if @errors.length > 0

  update_attributes: (attributes) ->
    for key, value of attributes
      @.attributes[key] = value

  will_be_destroy: ->
    return true if @.get('_destroy') == "true"

  is_master: ->
    return true if @.get('is_master') == true

  master_picture: ->
    pictures = @attributes.pictures_attributes or @attributes.pictures
    master_pic = _.find pictures, (p) ->
      return p if p.is_master == true and p._destroy == undefined
    return master_pic

