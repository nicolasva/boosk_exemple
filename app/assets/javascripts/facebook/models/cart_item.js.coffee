class App.CartItem extends Backbone.Model
  url: ->
    base = "/#{App.ui()}/shops/#{App.current_shop}"
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @page

  validate: (attributes) ->
    @errors = new Array()
    @key = ""
    @val = "" 
    @cart_item = ""
    if attributes.cart_item?
      @cart_item = attributes.cart_item 
    else
      @cart_item = attributes

    @array_option_type_error = new Array()
    self = @
    if @cart_item.option_type
      $.each(@cart_item.option_type, (key, val) ->
        self.array_option_type_error.push(key) if val == "undefined"
      )
      @errors.push "Veuillez sélectionner vos choix de "+@array_option_type_error.join(", de")+" afin de procéder à votre achat." if @array_option_type_error.length > 0 
    return @errors if @errors.length > 0
