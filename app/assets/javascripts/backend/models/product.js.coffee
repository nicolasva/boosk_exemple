class App.Product extends Backbone.Model

  defaults:
    taxon_ids: []

  url: ->
    base = "/shops/#{App.current_shop}/products"
    return base  if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

  initialize: (attributes) ->
    if attributes && attributes.shipping_category
      @shipping_category = new App.ShippingCategory attributes.shipping_category
    else
      @shipping_category = new App.ShippingCategory

  validate: (attributes, translate) ->
    @errors ||= []
    if @price != undefined
      if isNaN(@price) == true
        @errors.push translate.views.product.error.price_must_be_number
      if @price < 0
        @errors.push translate.views.product.error.price_must_be_positiv

    return true if @errors.length > 0


  getName: ->
    return @.get('name')


  getVariants: ->
    return @.get('product_variants')


  hasVariants: () ->
    return true if @.getVariants().length > 1


  add_variants_by_collection: (variants) ->
    @.set(product_variants_attributes: [])
    for variant in variants.toArray()
      if variant.attributes.option_types != undefined
        if variant.attributes.option_type_ids == undefined
          variant.set({option_type_ids: []})
          for option_type in variant.attributes.option_types
            variant.get('option_type_ids').push(option_type.id)
        delete variant.attributes.option_types
      if variant.attributes.pictures != undefined
        variant.set({pictures_attributes: []})
        for picture in variant.attributes.pictures
          variant.get('pictures_attributes').push(picture)
        delete variant.attributes.pictures
      @.attributes.product_variants_attributes.push(variant.attributes)
      delete @.attributes.product_variants if @.attributes.product_variants != undefined


  destroy_variant_by_diff: (old_variants) ->
    new_variants = @.get_variant_ids()
    for old_variant in old_variants
      unless new_variants.contains(old_variant)
        @.attributes.product_variants_attributes.push({id: old_variant, _destroy: 1})

  get_variant_ids: ->
    ids = []
    for variant in @.get('product_variants') or @.get('product_variants_attributes')
      ids.push variant.id if variant.id != undefined
    return ids

  add_variant: (variant) ->
    @.set(product_variants_attributes: [])
    @.attributes.product_variants_attributes.push(variant.attributes)


  getMaster: ->
    if @.getVariants()?
      for variant in @.getVariants()
        return variant if variant.is_master == true


  remove_all_product_variants: ->
    for variant in @.get('product_variants')
      variant['_destroy'] = true

