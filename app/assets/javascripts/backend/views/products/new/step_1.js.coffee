App.Views.Products ||= {}
App.Views.Products.New ||= {}

class App.Views.Products.New.Step1 extends Backbone.View
  template: JST["backend/templates/products/new/step_1"]

  tagName: "section"
  id: "new_product"
  className: "container-fluid"

  form_id: '#new_product_form'

  default_quantity: 1
  notice: '#notice'
  only_master: '.only-master'
  actions: '.actions'
  step: "#step"
  product_status: 'status'
  product_highlight: 'highlight'
  select_taxon_ids: '#product_taxon_ids'

  events:
    "submit #new_product_form": "add_product"
    "click .status,.highlight": "switch_on_off"
    "click .has-variants": "has_variants"
    "mouseover .master": "show_picture_button"
    "mouseout .master": "hide_picture_button"
    "mouseover #carousel": "show_carousel_arrow"
    "mouseout #carousel": "hide_carousel_arrow"
    "click #update-master-picture": "add_pictures"


  initialize: (options) ->
    @product = options.product
    @shop = options.shop
    @product.has_variants = false if @product.has_variants == undefined
    @taxonomies = new App.Collections.Taxonomies
    @translate = @options.translate.toJSON()
    @variant_master = new App.ProductVariant
    @pictures = new App.Collections.VariantsPictures
    if @product.pictures?
      for raw_picture in @product.pictures
        picture = new App.VariantsPicture
        picture.set {url: raw_picture.url, cached_path: raw_picture.cached_path}
        picture.cid = picture.get('cached_path')
        @pictures.add picture
      @variant_master.set 'pictures_attributes', @product.pictures
    @taxes = new App.Collections.TaxRates
    @variant_master.off "error"
    @variant_master.on "error", (model, error) ->
      $('html, body').scrollTop(0)
      new App.Views.Notice(message: model.errors, type: 'error' )
      delete model.errors
      model.valid = false
    @product.off "error"
    @product.on "error", (model, error) ->
      $('html, body').scrollTop(0)
      new App.Views.Notice(message: self.product.errors, type: 'error' )
      delete self.product.errors

    self = @
    App.eventsDispatcher.trigger 'startLoading'
    @taxes.fetch
      success: ->
        self.render()
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'


  show_carousel_arrow: (e) ->
    $('.arrow-left,.arrow-right').show()

  hide_carousel_arrow: (e) ->
    $('.arrow-left,.arrow-right').hide()

  add_product: (e) ->
    e.preventDefault()
    e.stopPropagation()
    data = $(@form_id).toJSON()
    @product.sku = data.sku
    @product.price = data.price
    @product.weight = data.weight
    @product.width = data.width
    @product.height = data.height
    @product.depth = data.depth
    unless @product.has_variants
      @product.quantity = data.quantity
    else
      @product.quantity = @default_quantity
    self = @
    if @product.set(data.product, @translate)
      if @product.has_variants
        @product.pictures = @variant_master.get('pictures_attributes')
        window.location.hash = "#/products/new/step_2"
      else
        @save()


  save: ->
    self = @
    @variant_master.valid = true
    @variant_master.set({
      sku: @product.sku
      quantity: @product.quantity
      price: @product.price
      weight: @product.weight
      height: @product.height
      width: @product.width
      depth: @product.depth
    }, @translate)
    if @variant_master.valid
      @product.add_variant(@variant_master)
      @product.attributes = {product: @product.attributes}
      $('#new_product_form input[type="submit"]').attr('disabled', 'disabled')
      App.eventsDispatcher.trigger 'startLoading'
      @product.save @product.attributes,
        success: (model, response) ->
          App.eventsDispatcher.trigger 'loadingComplete'
          new App.Views.Notice(message: self.translate.views.product.notice.created_successfully, type: 'success', size: "large")
          $('html, body').scrollTop(0)
          window.location.hash = "#/products"
        error: (model, errors) ->
          App.eventsDispatcher.trigger 'loadingComplete'
          new App.Views.Notice(message: self.translate.views.product.error.save, type: 'error', size: "large" )
          $('html, body').scrollTop(0)
          window.location.hash = "#/products"

  show_picture_button: ->
    $("#update-master-picture").show()

  hide_picture_button: ->
    $("#update-master-picture").hide()

  add_pictures: ->
    variants = new App.Collections.ProductVariants @variant_master
    @view = new App.Views.Products.AddPictures(variants: variants, pictures: @pictures, translate: @translate)
    $('#modal').addClass('modal-variants-pictures')
    $('#modal .modal-body').html(@view.render().el)
    $('#modal .modal-header h3').html(@translate.views.picture.add_pictures.toUpperCase())
    self = @
    new App.Libs.UploadPicture({
      browse_button: 'pickfiles',
      container: 'container',
      }, (up, file, data) =>
        variants.add_pictures(data)
        @display_picture(data)
        picture = new App.VariantsPicture
        picture.set {url: data.url, cached_path: data.cached_name}
        picture.cid = picture.get('cached_path')
        @pictures.add picture
        self.view_pic.unbind() unless self.view_pic == undefined
        self.view_pic = new App.Views.Products.ProductVariantPictures(
          el: $('#pictures'),
          pictures: [picture],
          variants: variants,
          master_picture: variants.get_master_picture()
        )
      ,"product_variant_picture"
      , "#pickfiles .txt"
    )
    pictures = @uniq_variants_pictures(variants)
    if pictures.length > 0
      @view_pic.unbind() unless @view_pic == undefined
      @view_pic = new App.Views.Products.ProductVariantPictures(
        el: $('#pictures'),
        pictures: pictures,
        variants: variants,
        master_picture: variants.get_master_picture(),
        carousel: self.carousel
      )
    $('#modal').modal('show')
    self = @
    $('#modal').on 'hide', (e) ->
      $('#modal').removeClass('modal-variants-pictures')

  display_picture: (data) ->
    if $('#zone-pictures .master img.default').length > 0
      $('#zone-pictures .master img.default').remove()
    unless $('#zone-pictures .master img').length > 0
      $('#zone-pictures .master').append("
         <img src='#{data.url}'/>
      ")
    else
      $('#zone-pictures .variants-pictures').append("
         <div class='variant pic'><img src='#{data.url}'/></div>
      ")
      if @variant_master.get('pictures_attributes') != undefined
        if @variant_master.get('pictures_attributes').length > 0
          $('#carousel').show()
        if @carousel == undefined
          if @variant_master.get('pictures_attributes').length > 5
            $('#arrow').show()
            @carousel = new Carousel
              container: $('#carousel .overflow')
              nb_visible: 4
        else
          @carousel.add_item()

  uniq_variants_pictures: (variants) ->
    pictures = []
    for variant in variants.toArray()
      unless variant.get('pictures_attributes') == undefined
        for picture in variant.get('pictures_attributes')
          p = @pictures.getByCid(picture.cached_path)
          pictures.push(p) unless pictures.contains(p)
    return pictures

  switch_on_off: (e) ->
    e.preventDefault()
    e.stopPropagation()
    el = $(e.target).find('input')
    if $(e.target).hasClass(@product_status)
      if $(el).attr('value') == "1"
        $(el).attr('value', 0)
        $(e.target).prev().html(@translate.suspended.capitalize())
      else
        $(el).attr('value', 1)
        $(e.target).prev().html(@translate.enabled.capitalize())
    else if $(e.target).hasClass(@product_highlight)
      if $(el).attr('value') == "true"
        $(el).attr('value', "false")
        $(e.target).prev().html(@translate.nop.capitalize())
      else
        $(el).attr('value', "true")
        $(e.target).prev().html(@translate.yep.capitalize())
    @toggle_button(e)

  has_variants: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if @product.has_variants
      @product.has_variants = false
      $(e.target).prev().html(@translate.nop.capitalize())
      $(@step).hide()
      $(@only_master).show()
      $(@only_master).find('input').addClass('necessary')
      $(@only_master).find('input#quantity').addClass('number')
      $("#sku").addClass('necessary')
      $(@actions).find("input[type='submit']").attr('value', "> #{@translate.create}")
    else
      @product.has_variants = true
      $("#sku").removeClass('necessary')
      $(e.target).prev().html(@translate.yep.capitalize())
      $(@step).show()
      $(@only_master).hide()
      $(@only_master).find('input').removeClass('necessary')
      $(@only_master).find('input').removeClass('number')
      $(@actions).find("input[type='submit']").attr('value', "> #{@translate.next}")
    @toggle_button(e)

  toggle_button: (e) ->
    if $(e.target).hasClass('small-on')
      $(e.target).removeClass('small-on')
      $(e.target).addClass('small-off')
    else
      $(e.target).removeClass('small-off')
      $(e.target).addClass('small-on')

  render: ->
    option_types = @options.option_types.toJSON()
    $(@el).html(Haml.render(@template(), { locals: {
      option_types: option_types
      product: @product.toJSON()
      product_properties: @product
      master: @variant_master.toJSON()
      pictures: @pictures
      taxes: @taxes.toJSON()
      translate: @translate
      has_variants: @product.has_variants
      shop: @shop.toJSON()
    } }))
    self = @
    @taxonomies.fetch
      success: (collection, response) ->
        collection.each (taxonomy) ->
          $(self.select_taxon_ids).append new App.Views.Products.TaxonomyOptGroup(collection: taxonomy.taxons, model: self.product).el
    return @
