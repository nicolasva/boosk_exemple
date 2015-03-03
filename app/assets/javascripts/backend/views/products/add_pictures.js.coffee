App.Views.Products ||= {}
App.Views.Products.New ||= {}

class App.Views.Products.AddPictures extends Backbone.View
  template: JST['backend/templates/products/add_pictures']

  initialize: (options) ->
    @product_variants = options.variants
    @pictures = options.pictures
    @translate = options.translate

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      product_variants: @product_variants.toJSON(),
      translate: @translate
    }}))
    return @

