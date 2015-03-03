class App.Routers.Products extends Backbone.Router
  routes:
    "/products": "index_product"
    "/products/new/step_1": "new_product_step_1"
    "/products/new/step_2": "new_product_step_2"
    "/products/new/step_3": "new_product_step_3"
    "/products/:id/edit" : "edit"
    "/products/:id" : "show"
    "/products/:product_id/variants/:variant_id/edit": "edit_variant"

  initialize: ->
    @products = new App.Collections.Products()
    @option_types = new App.Collections.ProductOptionTypes()
    @shops = new App.Collections.Shops()
    @current_shop = App.current_shop
    self = @
    @shops.fetch success: (collection, response) ->
      new App.Views.Listshop(shops: collection, current_shop: self.current_shop)
    @translate = new App.Translate


  index_product: ->
    App.eventsDispatcher.trigger 'startLoading'
    @new_product = undefined
    @new_product_variants = undefined
    self = @
    @translate.fetch
      success: ->
        self.products.fetch
          success: (collection, response) ->
            if self.index_view
              self.index_view.close()
            self.index_view = new App.Views.Products.Index
              products: collection,
              translate: self.translate
            App.eventsDispatcher.trigger 'loadingComplete'
          error: ->
            App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  edit: (id) ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    product = new App.Product({id: id})
    @option_types.shop_id = App.current_shop
    product.fetch
      success: ->
        if _.isEmpty self.translate.attributes
          self.translate.fetch
            success: ->
              self.option_types.fetch
                success: (option_types, response) ->
                  self.editview.close() if self.editview
                  self.editview = new App.Views.Products.Edit
                    product: product
                    option_types: option_types
                    translate: self.translate
                    el: $('#app')
                error: ->
                  App.eventsDispatcher.trigger 'loadingComplete'
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'
        else
          self.option_types.fetch
            success: (option_types, response) ->
              self.editview.close() if self.editview
              self.editview = new App.Views.Products.Edit
                product: product
                option_types: option_types
                translate: self.translate
                el: $('#app')
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  show: (id) ->
    if @products.isEmpty()
      self = @
      App.eventsDispatcher.trigger 'startLoading'
      @products.fetch
        success: (collection, response) ->
          product = collection.get(id)
          self.product_variants = new App.Collections.ProductVariants()
          self.product_variants.reset(product.get("product_variants"))
          self.product_variants.shop_id = App.current_shop
          self.option_types.fetch
            success: (option_types, reponse) ->
              @view = new App.Views.Products.Show
                product: product,
                product_variants: self.product_variants,
                option_types: option_types
              $("#app").html(@view.render().el)
              App.eventsDispatcher.trigger 'loadingComplete'
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'
        error: ->
          App.eventsDispatcher.trigger 'loadingComplete'
    else
      product = @products.get(id)
      if @product_variants == undefined or @product_variants != undefined and
         @product_variants.models[0].attributes.product_id != parseInt(id)
        @product_variants = new App.Collections.ProductVariants()
        @product_variants.reset(product.get("product_variants"))
      @product_variants.shop_id = App.current_shop
      self = @
      App.eventsDispatcher.trigger 'startLoading'
      @option_types.fetch
        success: (option_types, reponse) ->
          @view = new App.Views.Products.Show
            product: product,
            product_variants: self.product_variants,
            option_types: self.option_types
          $("#app").html(@view.render().el)
          App.eventsDispatcher.trigger 'loadingComplete'
        error: ->
          App.eventsDispatcher.trigger 'loadingComplete'

  new_product_step_1: ->
    App.eventsDispatcher.trigger 'startLoading'
    @new_product ?= new @products.model()
    @new_product.shop_id = App.current_shop
    @shop = new App.Shop(uuid: App.current_shop)
    self = @
    if _.isEmpty @translate.attributes
      @translate.fetch
        success: ->
          self.shop.fetch
            success: ->
              self.option_types.fetch
                success: (collection, response) ->
                  @view = new App.Views.Products.New.Step1
                    product: self.new_product
                    option_types: collection
                    translate: self.translate
                    shop: self.shop
                  $("#app").html(@view.el)
                error: ->
                  App.eventsDispatcher.trigger 'loadingComplete'
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'
        error: ->
          App.eventsDispatcher.trigger 'loadingComplete'
    else
      @option_types.fetch
        success: (collection, response) ->
          self.shop.fetch
            success: ->
              @view = new App.Views.Products.New.Step1
                product: self.new_product
                option_types: collection
                translate: self.translate
                shop: self.shop
              $("#app").html(@view.el)
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'
        error: ->
          App.eventsDispatcher.trigger 'loadingComplete'

  new_product_step_2: ->
    unless @new_product == undefined
      unless @new_product_variants
        @new_product_variants = new App.Collections.ProductVariants()
      @view = new App.Views.Products.New.Step2
        product: @new_product,
        option_types: @option_types,
        product_variants: @new_product_variants,
        translate: @translate
      $("#app").html(@view.render().el)
    else
      window.location.hash = "#/products/new/step_1"

  new_product_step_3: ->
    unless @new_product_variants == undefined
      @view = new App.Views.Products.New.Step3
        product: @new_product,
        option_types: @option_types,
        product_variants: @new_product_variants,
        translate: @translate
      $("#app").html(@view.render().el)
    else
      window.location.hash = "#/products/new/step_2"
