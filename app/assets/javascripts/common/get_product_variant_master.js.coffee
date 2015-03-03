App.GetProductVariantMaster = (product_variants) ->
  product_variants_master = product_variants[0]
  $.each(product_variants, (key, val) ->
    product_variants_master = val if val.is_master && !_.isEqual(val, product_variants_master)
  )
  product_variants_master
