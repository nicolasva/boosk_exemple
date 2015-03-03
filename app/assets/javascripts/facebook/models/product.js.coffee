class App.Product extends Backbone.Model
  url: ->
    base = "/#{App.ui()}/shops/#{App.current_shop}/products"
    return base if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

  getVariants: ->
    return @.get('product_variants')

  getProductUuid: ->
    return @.get('uuid') 

  hasVariants: () ->
    return true if @.getVariants().length > 1
