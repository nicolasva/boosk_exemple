class App.Views.Products.Index extends Backbone.View
  template: JST["backend/templates/products/index"]

  line_template: JST["backend/templates/products/product_line"]

  el: "#app"

  events:
   "click .remove-product" : "destroy"
   "click .next" : "next"
   "click .prev" : "prev"
   "click #paginate a[data-num]" : "at_page"
   "change .action": "perform_action"
   "change select[name='view_per_page']": "per_page"
   "click .select-all": "select_all_products"
   "click .pictos-position span": "change_pos_by_click"
   "click .product-status": "toggle_status"
   "click #import": "import"

  initialize: (options) ->
    @products = options.products
    @option_types = options.option_types
    @translate = options.translate.toJSON()
    @actions =
      0: { action: "destroy", display: @translate.delete.capitalize() }
      1: { action: "copy", display: @translate.duplicate.capitalize() }
    self = @
    @render()

    @products.on 'reset', ->
      if _.isEmpty(self.format_products())
        self.prev()
      else
        self.render()


  perform_action: (e) ->
    e.preventDefault()
    e.stopPropagation()
    perform = @actions[$(e.target).val()]
    if perform != undefined
      eval "this.#{perform['action']}()"
      $('.action option:first-child').attr('selected','selected')


  format_products: ->
    products = []
    for product in @products.models
      products.push {variant_master: product.getMaster(), attr: product.attributes}
    return products


  destroy: (event) ->
    products = @get_products_selected($('.product-selected'))
    if _.isEmpty(products)
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.product.warning.select_product_before
        el: $('#modal .modal-body')
        mode: "alert"
    else
      self = @
      @popup.close() if @popup != undefined
      @popup = new App.Views.Popup
        translate: @translate
        message: if products.length > 1 then @translate.views.product.warning.remove_confirm.other else @translate.views.product.warning.remove_confirm.one
        el: $('#modal .modal-body')
        mode: "confirm"
        callback: ->
          App.eventsDispatcher.trigger 'startLoading'
          self.products.bulk_destroy products,
            success: (models, products) ->
              for product in products
                self.products.remove self.products.get(product.id)
                $("tr[data-id=#{product.id}]").remove()
              if self.products.length is 1
                $("#products tbody").sortable( "disable" )
                $('#products table tbody tr:first-child .pictos-position .up-active').removeClass('up-active').addClass('up-unactive')
              for item in $('#products table tbody tr')
                index = $(item).index() + 1
                product = self.products.get($(item).attr('data-id'))
                product.set({position: index})
                self.swap_pictos_position(index,item)
              App.eventsDispatcher.trigger 'loadingComplete'
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'

  import: (e) ->
    e.preventDefault()
    e.stopPropagation()
    new App.Views.Products.Import(translate: @translate)

  copy: (event) ->
    products = @get_products_selected($('.product-selected'))
    if _.isEmpty(products)
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.product.warning.select_product_before
        el: $('#modal .modal-body')
        mode: "alert"
    else
      self = @
      @popup.close() if @popup != undefined
      @popup = new App.Views.Popup
        translate: @translate
        message: if products.length > 1 then @translate.views.product.warning.duplicate_confirm.other else @translate.views.product.warning.duplicate_confirm.one
        el: $('#modal .modal-body')
        mode: "confirm"
        callback: ->
          App.eventsDispatcher.trigger 'startLoading'
          self.products.bulk_copy products,
            success: (models, products) ->
              max_ptds = false
              for product in products
                product = new App.Product(product)
                self.products.add(product)
                if parseInt(self.products.models.length) < parseInt(self.products.perPage)
                  $("#products table tbody tr:last-child").find('.pictos-position .down-unactive')
                  .removeClass('down-unactive').addClass('down-active')
                  $('#products table tbody').append(
                    Haml.render(self.line_template(), { locals: {
                      product: product
                      translate: self.translate
                    }}))
                  $('#products table tbody tr:last-child').fadeIn(800)
                else if !max_ptds
                  max_ptds = true
              if max_ptds
                self.products.page = Math.ceil((self.products.total + products.length) / self.products.perPage)
                self.products.fetch()
              App.eventsDispatcher.trigger 'loadingComplete'
            error: ->
              App.eventsDispatcher.trigger 'loadingComplete'

  prev: (e) ->
    if e?
      e.stopPropagation()
      e.preventDefault()
    @products.previousPage()
    return false

  next: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @products.nextPage()
    return false

  per_page: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @products.viewPerPage(parseInt $(e.target).val())
    return false

  at_page: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @products.atPage(parseInt $(e.target).attr('data-num'))
    return false


  select_all_products: (e) ->
    if $(e.target).is(':checked')
      for variant in $('.product-selected')
        variant.checked = true
      $("button[data-toggle='modal']").removeAttr('disabled')
    else
      for variant in $('.product-selected')
        variant.checked = false
      $("button[data-toggle='modal']").attr('disabled', 'disabled')


  get_products_selected: (products) ->
    products_selected = []
    for product in products
      if $(product).is(':checked')
        id = $(product).parents('tr').attr('data-id')
        products_selected.push(@products.get(id))
    return products_selected


  change_pos_by_click: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if @products.models.length > 1
      switch $(e.target).attr('class')
        when 'down-active'
          $(e.target).parents('tr').insertAfter($(e.target).parents('tr').next())
          id = $(e.target).parents('tr').attr('data-id')
          index = parseInt($(e.target).parents('tr').index() + 1)
          @change_position(id, index, $(e.target).parents('tr'))
          @swap_pictos_position(index,$(e.target).parents('tr'))
        when 'up-active'
          $(e.target).parents('tr').insertBefore($(e.target).parents('tr').prev())
          id = $(e.target).parents('tr').attr('data-id')
          index = parseInt($(e.target).parents('tr').index() + 1)
          @change_position(id, index, $(e.target).parents('tr'))
          @swap_pictos_position(index,$(e.target).parents('tr'))


  set_sortable_position: ->
    self = @
    if @products.models.length > 1
      $( "#products tbody" ).sortable(
        handle: ".sortable"
        placeholder: "ui-sortable-placeholder"
        helper: (e, ui) ->
          ui.children().each ->
            $(@).width($(@).width())
          return ui
        start: (e, ui) ->
          $('#products table').addClass('deactivate-text-select')
          $(ui.item).addClass('line-ondrag')
          ui.placeholder.height(ui.item.height())
          ui.placeholder.width(ui.item.width())
          #TEMP
          $(ui.placeholder).html('<td></td><td></td><td></td><td>
          </td><td></td><td></td><td></td><td></td>')
        stop: (e,ui) ->
          $(ui.item).removeClass('line-ondrag')
          id = $(ui.item).attr('data-id')
          index = parseInt($(ui.item).index() + 1)
          self.change_position(id, index, ui.item)
          self.swap_pictos_position(index,ui.item)
          $('#products table').removeClass('deactivate-text-select')
      )

  swap_pictos_position: (index,el) ->
    if index is 1
      $(el).find('.pictos-position .up-active').removeClass('up-active').addClass('up-unactive')
      $(el).find('.pictos-position .down-unactive').removeClass('down-unactive').addClass('down-active')
      $(el).next().find('.pictos-position .up-unactive').removeClass('up-unactive').addClass('up-active')
      $('#products table tbody tr:last-child .pictos-position .down-active').removeClass('down-active').addClass('down-unactive')
    else if index is $('#products table tbody tr').length
      $('#products table tbody tr:first-child .pictos-position .up-active').removeClass('up-active').addClass('up-unactive')
      $(el).find('.pictos-position .down-active').removeClass('down-active').addClass('down-unactive')
      $(el).find('.pictos-position .up-unactive').removeClass('up-unactive').addClass('up-active')
      $(el).prev().find('.pictos-position .down-unactive').removeClass('down-unactive').addClass('down-active')
    else
      $(el).find('.pictos-position .up-unactive').removeClass('up-unactive').addClass('up-active')
      $(el).find('.pictos-position .down-unactive').removeClass('down-unactive').addClass('down-active')
      $('#products table tbody tr:last-child .pictos-position .down-active').removeClass('down-active').addClass('down-unactive')
      $('#products table tbody tr:first-child .pictos-position .up-active').removeClass('up-active').addClass('up-unactive')


  change_position: (id, index,el) ->
    self = @
    product = @products.get(id)
    unless product.get('position') is index
      product.set({old_position: product.get('position'),position: index})
      App.eventsDispatcher.trigger 'startLoading'
      product.save product.attributes,
        success: ->
          for item in $('#products table tbody tr')
            product = self.products.get($(item).attr('data-id'))
            product.set({position: ($(item).index() + 1)})
          App.eventsDispatcher.trigger 'loadingComplete'
        error: ->
          App.eventsDispatcher.trigger 'loadingComplete'


  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      products: @format_products()
      shop_id: App.current_shop
      paginate: @products.pageInfo()
      translate: @translate
      actions: @actions
      view_per_page: [10,15,20,30,100]
    } }))

    @set_sortable_position()

    return @

  close: ->
    $(@el).unbind()
    $(@el).empty()

  toggle_status: (e)->
    product = @products.get($(e.currentTarget).closest("tr").attr("data-id"))
    self = @
    if($(e.currentTarget).hasClass("product-activated"))
      product.set({status: false})
      product.save {status: false},
        success: ->
          $(e.currentTarget).removeClass("product-activated")
          $(e.currentTarget).addClass("product-deactivated")
          $(e.currentTarget).find("span:first").text(self.translate.suspended.toUpperCase())
    else
      product.set({status: true})
      product.save {status: true},
        success: ->
          $(e.currentTarget).removeClass("product-deactivated")
          $(e.currentTarget).addClass("product-activated")
          $(e.currentTarget).find("span:first").text(self.translate.enabled.toUpperCase())