class App.Shop extends Backbone.Model
  defaults:
    name: ""
    baseline: ""
    description: ""
    has_active_payement: "true"
    url_website: ""
    data_product_feed_url: ""

  initialize: ->
    @customization = new App.Customization;
    @customization.url = "/shops/#{App.current_shop}/customization";
    @id = @attributes['uuid']

  url: ->
    base = "/shops"
    return "/wizard" if @wizard != undefined
    return base  if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

  validate: (attributes) ->
    @errors = []
    if attributes.shop?
      @errors.push "Name can't be empty" unless attributes.shop.name? and attributes.shop.name isnt ""
    else
      @errors.push "Name can't be empty" unless attributes.name? and attributes.name isnt ""
    return @errors if @errors.length > 0
