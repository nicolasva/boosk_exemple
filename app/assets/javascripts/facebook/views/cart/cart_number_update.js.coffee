class App.Views.Cart.CartNumberUpdate extends Backbone.View
  template: JST["facebook/templates/cart/cart_number_update"]
  initialize: (options) ->
    @cart = options.cart
    @el = "#cartitem_show_basket_"+options.cart.id 
    @render()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: { cart: @cart.toJSON() } })) 
    @load_product_variant_picture() 
    
  load_product_variant_picture: ->
    product_variant_pictures = new App.Collections.ProductVariantPictures()
    product_variant_pictures.product_id = @cart.toJSON().product.product_id
    product_variant_pictures.product_variant_id = @cart.toJSON().id
    cart = @cart
    product_variant_pictures.fetch
      success: (collections, response) ->
        @ViewProductVariantPictures = new App.Views.ProductVariantPictures.Show(product_variant_pictures: collections, product_id: cart.toJSON().product.product_id)  


     
