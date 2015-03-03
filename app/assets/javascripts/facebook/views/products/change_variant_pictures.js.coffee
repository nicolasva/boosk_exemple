class App.Views.Products.ChangeVariantPictures extends Backbone.View
  el: '#pictures'

  template: JST["facebook/templates/products/change_variant_pictures"]

  events:
    "mouseover #carousel": "show_carousel_arrow"
    "mouseout #carousel": "hide_carousel_arrow"
    "mouseover .pic": "display_pic_frame"

  initialize: (options) ->
    @variant = options.variant
    @ViewPanelSetAttributesAfterAction = new App.CommonViews.ProductVariants.ChangePriceWithVariant({price: @variant.toJSON().price_ttc})
    @setElement(@el)
    @render()
    @carousel = new Carousel
      container: $('#carousel .overflow')
      nb_visible: 4

  display_pic_frame: (e) ->
    master_picture = $('.master').find('img')
    src = $(e.currentTarget).find('img').attr('src')
    if master_picture != src
      $('.master').find('img').attr('src', src)


  show_carousel_arrow: (e) ->
    if @carousel.right_click > 0
      $('.arrow-right').show()
    if @carousel.left_click > 0
      $('.arrow-left').show()

  hide_carousel_arrow: (e) ->
    $('.arrow-left,.arrow-right').hide()


  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      variant: @variant.toJSON()
    }}))
