class App.Collections.ProductVariants extends Backbone.Collection

  getMaster: ->
    product_variants = @.toArray()
    for variant in product_variants
      return variant if variant.attributes.is_master == true
    return false

  getOptionTypes: ->
    option_types = {keys: new Array, ids: new Array}

    for variant in @.toArray()
      if variant.get('option_types') != undefined
        for option_type in variant.get('option_types')
          unless _.include(option_types.ids, option_type.id)
            option_types.ids.push option_type.id
          unless _.include(option_types.keys, option_type.name)
            option_types.keys.push option_type.name
    return option_types


  findByOptionTypes: (selected_option_type_ids) ->
    variants = new Array

    for variant in @.toArray()
      match = true
      option_type_ids = new Array

      for option_type in variant.get('option_types')
        option_type_ids.push option_type.id

      for selected_id in selected_option_type_ids
        match = false unless _.include(option_type_ids, selected_id)

      variants.push variant if match == true
    return variants

  findExactlyByOptionTypes: (selected_option_type_ids) ->
    product_variant = null

    for variant in @.toArray()
      option_type_ids = (option_type.id for option_type in variant.get('option_types'))

      if selected_option_type_ids.length == option_type_ids.length and _.difference(option_type_ids, selected_option_type_ids).length == 0
        product_variant = variant

    return product_variant


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
          if _.include(variant_option_type_ids, option_type)
            if _.include(variant_option_type_ids, selected_id)
              match_variant.push(true)
            else
              match_variant.push(false)
          else
            match_variant.push(false)

        if _.include(match_variant, false) then global_match.push(false) else global_match.push(true)

      unselectable.push option_type unless _.include(global_match, true)

    return unselectable


  check_init_option_type_unselectable: (all_option_types_json) ->
    unselectable = new Array
    all_option_types = new Array()
    $.each(all_option_types_json, (key, val) ->
      #all_option_types.push(val.values.id)
      $.each(val.values, (key_content, content) ->
        all_option_types.push(content.id)
      )
    )

    for option_type in all_option_types
      global_match = new Array

      for variant in @.toArray()
        match_variant = new Array

        variant_option_type_ids = new Array

        for variant_option_type in variant.get('option_types')
          variant_option_type_ids.push variant_option_type.id

          if _.include(variant_option_type_ids, option_type)
              match_variant.push(true)
          else
              match_variant.push(false)

        if _.include(match_variant, false) then global_match.push(false) else global_match.push(true)

      unselectable.push option_type unless _.include(global_match, true)

    return unselectable
