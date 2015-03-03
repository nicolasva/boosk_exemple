App.Views.Products ||= {}
App.Views.Products.Edit ||= {}

class App.Views.Products.Edit.Master extends App.Views.Products.Edit
  template: JST["backend/templates/products/edit/master"]

  select_taxon_ids: '#product_taxon_ids'

  product_status: 'status'
  product_highlight: 'highlight'

  events:
    "click .has-variants": "has_variants"
    "click .status,.highlight": "switch_on_off"
    "mouseover .master": "show_picture_button"
    "mouseout .master": "hide_picture_button"
    "mouseover #carousel": "show_carousel_arrow"
    "mouseout #carousel": "hide_carousel_arrow"
    "click #update-master-picture": "add_pictures"

  initialize: (options) ->
    @translate = options.translate
    @product = options.product
    @shop = options.shop
    @product_variants = options.product_variants
    @product.has_variants = true if @product.hasVariants()
    @pictures = options.pictures
    @taxes = options.taxes
    @taxonomies = new App.Collections.Taxonomies

    $("#step .step, #edit_product_form input[type='submit']").bind 'click',@,@update_master


  update_master: (e) =>
    data = $(@form_id).toJSON()
    @product.set(data.product)
    master = @product_variants.getMaster()
    master.update_attributes(data.product_variant)

  show_carousel_arrow: (e) ->
    $('.arrow-left,.arrow-right').show()

  hide_carousel_arrow: (e) ->
    $('.arrow-left,.arrow-right').hide()

  format_product: ->
    return {master: @product_variants.getMaster().toJSON(), attr: @product.attributes}


  has_variants: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if @product.has_variants
      @product.has_variants = false
      $(e.target).prev().html(@translate.nop.capitalize())
    else
      @product.has_variants = true
      $(e.target).prev().html(@translate.yep.capitalize())
    @toggle_button(e)


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


  show_picture_button: ->
    $("#update-master-picture").show()

  hide_picture_button: ->
    $("#update-master-picture").hide()

  add_pictures: ->
    variants = new App.Collections.ProductVariants @product_variants.getMaster()
    unless variants.length == 0
      @view = new App.Views.Products.AddPictures
        variants: variants
        pictures: @pictures
        translate: @translate
      $('#modal').addClass('modal-variants-pictures')
      $('#modal .modal-body').html(@view.render().el)
      $('#modal .modal-header h3').html(@translate.views.picture.add_pictures.toUpperCase())
      self = @
      pictures = @uniq_variants_pictures(variants)
      if pictures.length > 0
       @view_pic.unbind() unless @view_pic == undefined
       @view_pic =  new App.Views.Products.ProductVariantPictures(
          el: $('#pictures'),
          pictures: pictures,
          variants: variants,
          master_picture: variants.get_master_picture()
        )
      $('#modal').on 'hidden', () ->
        $('#modal').removeClass('modal-variants-pictures')
      $('#modal').off 'shown'
      $('#modal').on 'shown', () ->
        new App.Libs.UploadPicture({
          browse_button: 'pickfiles',
          container: 'container',
          }, (up, file, data) =>
            variants.add_pictures(data)
            self.display_picture(data)
            picture = new App.VariantsPicture
            picture.set {url: data.url, cached_path: data.cached_name}
            picture.cid = picture.get('cached_path')
            self.pictures.add picture
            self.view_pic.unbind() unless self.view_pic == undefined
            self.view_pic = new App.Views.Products.ProductVariantPictures(
              el: $('#pictures'),
              pictures: [picture],
              variants: variants,
              master_picture: variants.get_master_picture(),
              carousel: self.carousel
            )
          ,"product_variant_picture"
          , "#pickfiles .txt"
        )
      $('#modal').modal('show')

  display_picture: (data) ->
    unless $('#zone-pictures .master img').length > 0
      $('#zone-pictures .master').append("
         <img src='#{data.url}'/>
      ")
    else
      $('#zone-pictures .variants-pictures').append("
         <div class='variant pic'><img src='#{data.url}'/></div>
      ")
      if @carousel == undefined
        if @product_variants.getMaster().get('pictures').length > 5
          $('#arrow').show()
          @carousel = new Carousel
            container: $('#carousel .overflow')
            nb_visible: 4
      else
        @carousel.add_item()


  uniq_variants_pictures: (variants) ->
    pictures = []
    for variant in variants.toArray()
      unless variant.get('pictures') == undefined
        for picture in variant.get('pictures')
          if picture._destroy == undefined
            p = @pictures.getByCid(picture.cached_path)
            pictures.push(p) unless pictures.contains(p)
    return pictures


  toggle_button: (e) ->
    if $(e.target).hasClass('small-on')
      $(e.target).removeClass('small-on')
      $(e.target).addClass('small-off')
    else
      $(e.target).removeClass('small-off')
      $(e.target).addClass('small-on')


  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      product: @format_product()
      shop: @shop.toJSON()
      product_properties: @product
      translate: @translate
      pictures: @pictures
      taxes: @taxes.toJSON()
    } }))
    self = @
    @taxonomies.fetch
      success: (collection, response) ->
        collection.each (taxonomy) ->
          $(self.select_taxon_ids).append new App.Views.Products.TaxonomyOptGroup(collection: taxonomy.taxons, model: self.product).el
    return @
