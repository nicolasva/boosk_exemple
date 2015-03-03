class App.Collections.ProductVariants extends Backbone.Collection
  model: App.ProductVariant

  url: ->
    unless @attributes.product_variant == undefined
      product_id = @attributes.product_variant.product_id
    else
      product_id = @attributes.product_id
    base = "/shops/#{App.current_shop}/products/#{product_id}/product_variants"
    return base  if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id


  getMaster: ->
    product_variants = @.toArray()
    for variant in product_variants
      return variant if variant.attributes.is_master == true
    return false

  getOptionTypes: ->
    option_types = {keys: new Array, ids: new Array}

    for variant in _.filter(@.toArray(),(d) -> return d.get('_destroy') is undefined)
      if variant.get('option_types') != undefined
        for option_type in variant.get('option_types')
          unless option_types.ids.contains option_type.id
            option_types.ids.push option_type.id
          unless option_types.keys.contains option_type.name
            option_types.keys.push option_type.name
    return option_types


  add_pictures: (data) ->
    if @get_master_picture() == null
      picture = { cached_path: data.cached_name, is_master: true, url: data.url }
    else
      picture = { cached_path: data.cached_name, is_master: false, url: data.url }
    for variant in @.toArray()
      if variant.get('pictures') == undefined
        unless variant.get('pictures_attributes') != undefined
          variant.set('pictures_attributes', [picture])
        else
          variant.attributes.pictures_attributes.push(picture)
      else
        variant.attributes.pictures.push(picture)
    @set_master_picture()


  destroy_picture: (cached_path) ->
    v = []
    for variant in @.toArray()
      if variant.get('pictures') != undefined
        picture = _.find variant.get('pictures'), (pic) ->
          return pic.cached_path is cached_path
        if picture != undefined
          picture['_destroy'] = 1
          picture.is_master = false
          v.push variant
      else
        picture = _.find variant.get('pictures_attributes'), (pic) ->
          return pic.cached_path is cached_path
        if picture != undefined
          variant.get('pictures_attributes').splice(_.indexOf(variant.get('pictures_attributes'), picture), 1)
          v.push variant
    return v


  change_master_picture: (cached_path) ->
    for variant in @.toArray()
      pictures = variant.attributes.pictures_attributes or variant.attributes.pictures
      for picture in pictures
        if picture.cached_path == cached_path
          picture.is_master = true
        else
          picture.is_master = false


  get_pictures: ->
    all_pictures = []
    for variant in @.toArray()
      pictures = variant.attributes.pictures_attributes or variant.attributes.pictures
      for picture in pictures
        picture.cached_path = 'default_picture' if picture.picture.url == App.default_product_picture_url
        all_pictures.push(picture)
    return all_pictures


  get_master_picture: ->
    master = null
    for variant in @.toArray()
      pictures = variant.attributes.pictures_attributes or variant.attributes.pictures
      if pictures != undefined
        for picture in pictures
          if picture['_destroy'] == undefined
            if picture.is_master == true
              master = picture.cached_path
    return master


  set_master_picture: ->
    master = null
    for variant in @.toArray()
      pictures = variant.attributes.pictures_attributes or variant.attributes.pictures
      if pictures != undefined
        for picture in pictures
          if picture.is_master == true
            unless master == null
              picture.is_master = false
    return master


  findByOptionTypes: (selected_option_type_ids) ->
    variants = new Array

    for variant in @.toArray()
      match = true
      option_type_ids = new Array

      for option_type in variant.get('option_types')
        option_type_ids.push option_type.id

      for selected_id in selected_option_type_ids
        match = false unless option_type_ids.contains selected_id

      variants.push variant if match == true
    return variants


  check_unselectable: (select_option_type_id, select_option_types) ->
    unselectable = new Array
    all_option_types = new Array

    for option_type in $(select_option_types)
      for option in $(option_type).find('option')
        all_option_types.push parseInt(option.value) if parseInt(option.value)

    for option_type in all_option_types
      global_match = new Array

      for variant in @.toArray()
        match_variant = new Array

        variant_option_type_ids = new Array

        for variant_option_type in variant.get('option_types')
          variant_option_type_ids.push variant_option_type.id

        for selected_id in select_option_type_id
          if variant_option_type_ids.contains(option_type)
            if variant_option_type_ids.contains(selected_id)
              match_variant.push(true)
            else
              match_variant.push(false)
          else
            match_variant.push(false)

        if match_variant.contains(false) then global_match.push(false) else global_match.push(true)

      unselectable.push option_type unless global_match.contains(true)

    return unselectable


  option_types_to_a: ->
    all_option_types = []
    for variant in @.toArray()
      option_types = []
      if variant.get('option_types') != undefined
        for option in variant.get('option_types')
          option_types.push option.id
        all_option_types.push {option_ids: option_types, variant_cid: variant.cid}
    return all_option_types


  attributes_to_a: ->
    all_attributes = []
    for variant in @.toArray()
      all_attributes.push {attributes: variant.attributes, variant_cid: variant.cid}
    return all_attributes


  add_variants_by_option_types: (option_types_selected, option_types, product) ->
    exp_option_types = []
    first_selected = []

    for v in option_types_selected[0]
      first_selected.push(v)
    option_types_selected.splice(0,1)

    for selected in first_selected
      mashups = @option_by_first_selected(selected, option_types_selected)
      for mashup in mashups
        product_variant = new @.model()
        product_variant.set({
          sku: product.sku,
          price: product.price,
          quantity: product.quantity
          width: product.width
          height: product.height
          weight: product.weight
          depth: product.depth
        })
        variant_option_types = []
        for vop in option_types.toJSON()
          for op in vop.values
            variant_option_types.push op if mashup.contains(op.id)
        product_variant.set({option_types: variant_option_types})
        product_variant.set({option_type_ids: mashup})

        @.add(product_variant)


  edit_variants_by_option_types: (option_types_selected, option_types, product, to_destroy) ->
    exp_option_types = []
    first_selected = []
    mashups = []

    for v in option_types_selected[0]
      first_selected.push(v)
    option_types_selected.splice(0,1)
    for selected in first_selected
      mashups.push @option_by_first_selected(selected, option_types_selected)

    variant_option_types = @option_types_to_a()
    variant_attributes = @attributes_to_a()
    @.reset()
    not_match = []
    for mashup in _.flatten(mashups, true)
      match = false
      for variant_option_type in variant_option_types
        unless _.isEmpty(variant_option_type['option_ids'])
          match = _.all variant_option_type['option_ids'], (o) ->
            return mashup.contains o
        if match
          attributes = _.find variant_attributes, (a) ->
            return a['attributes'] if a['variant_cid'] == variant_option_type['variant_cid']
          product_variant = new @.model(attributes['attributes'])
          delete product_variant.id if @.get(product_variant) != undefined
          new_option_types = []
          for vop in option_types.toJSON()
            for op in vop.values
              new_option_types.push op if mashup.contains(op.id)
          product_variant.set({option_types: new_option_types})
          product_variant.set({option_type_ids: mashup})
          @.add(product_variant)
          break
       unless match
        product_variant = new @.model()
        new_option_types = []
        for vop in option_types.toJSON()
          for op in vop.values
            new_option_types.push op if mashup.contains(op.id)
        product_variant.set({sku: '', price: 0, quantity: 0})
        product_variant.set({option_types: new_option_types})
        product_variant.set({option_type_ids: mashup})
        product_variant.set({pictures: []})
        product_variant.set({is_master: true}) unless @getMaster()
        @.add(product_variant)


  option_by_first_selected: (first_selected, option_type_selected) ->
    mashups = []
    clone_mashups_els = []
    mashups.push([first_selected])

    for option_type in option_type_selected
      cpt = 0
      for value in option_type
        if option_type.length > 0
          if cpt > 0
            lol = App.clone(clone_mashups_els)
            for t in lol
              t.push(value)
              mashups.push(t)
          else
            clone_mashups_els = App.clone(mashups)
            for mashup in mashups
              mashup.push(value)
        else
          for mashup in mashups
            mashup.push(value)
        cpt++
    return mashups
