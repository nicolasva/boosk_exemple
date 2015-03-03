class App.CommonViews.Pint.PintItPinterest extends Backbone.View
  template: JST["facebook/common_templates/pint/pinterest/pint_it"]
  el: '#boxproductvariant'

  initialize: (options) ->
    @url_path = options.url_path
    @location = options.location
    @product = options.product
    @render()

  render: ->
    product_variants_master = App.GetProductVariantMaster(@product.toJSON().product_variants)
    picture_master = @get_pictures_master_of_product_variant_master(product_variants_master.pictures)
    $(@el).html(Haml.render(@template(), {locals: {location: @location, picture_url: @url_path+picture_master.picture.url, product_description: @product.toJSON().description}}))
    product = @product.toJSON()
    window.open(Haml.render(@template(), {locals: {
      location: @location,
      picture_url: @url_path+picture_master.picture.url,
      product: product
      }}),"Pint it","menubar=no, status=no, scrollbars=no, menubar=no, width=600, height=250")

  get_product_variant_master: (product_variants) ->
    product_variants_master = product_variants[0]
    $.each(product_variants, (key, val) ->
      product_variants_master = val if val.is_master && !_.isEqual(val, product_variants_master)
    )
    product_variants_master

  get_pictures_master_of_product_variant_master: (pictures) ->
    picture_master = pictures[0]
    $.each(pictures, (key, val) ->
      picture_master = val if val.is_master
    )
    picture_master
