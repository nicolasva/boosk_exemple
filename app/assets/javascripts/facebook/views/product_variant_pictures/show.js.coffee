class App.Views.ProductVariantPictures.Show extends Backbone.View
  template: JST["facebook/templates/product_variant_pictures/load_img_product_variant_picture_first"]

  initialize: (options) ->
    @product_variant_pictures = options.product_variant_pictures
    @product_id = options.product_id
    @el = "#id_cart_item_" + options.product_variant_pictures.product_variant_id + "_" + options.product_id
    @render()

  render: ->
    picture_url = @get_variant_pictures_master(@product_variant_pictures.toJSON())
    $(@el).html(Haml.render(@template(), {locals: {picture_url: picture_url}})) 

  get_variant_pictures_master: (product_variant_pictures_collections) ->
    product_variant_picture_url = product_variant_pictures_collections[0].picture.url
    $.each(product_variant_pictures_collections, (key, val) ->
      product_variant_picture_url = val.picture.url  if val.is_master && !_.isEqual(val, product_variant_picture_url) 
    )
    product_variant_picture_url
   
     
  
