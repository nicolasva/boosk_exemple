class App.Views.ProductVariantPictures.LoadImgProductVariantPictureFirst extends Backbone.View
  template: JST["facebook/templates/product_variant_pictures/load_img_product_variant_picture_first"]

  initialize: (options) ->
    @render()

  render: ->
    @loading_pictures_product_variant() 

  loading_pictures_product_variant: -> 
    template = @template
    product_variant_pictures = new App.Collections.ProductVariantPictures()
    $('div.product_variant_picture_url').each (data) ->
      class_product_variant_id = $(this) 
      product_variant_pictures.product_variant_id = $(this).attr("id").split("_")[3]
      product_variant_pictures.product_id = $(this).attr("id").split("_")[4]
 
      product_variant_pictures.fetch 
        success: (collection, response) ->
          if collection.toJSON().length > 0
            $(class_product_variant_id).html(Haml.render(template(), { locals: { picture_url:  collection.toJSON()[0].picture.url}})) 
