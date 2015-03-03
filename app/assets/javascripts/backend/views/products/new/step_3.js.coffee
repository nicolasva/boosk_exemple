App.Views.Products ||= {}
App.Views.Products.New ||= {}

class App.Views.Products.New.Step3 extends Backbone.View
  template: JST["backend/templates/products/new/step_3"]

  tagName: "section"
  id: "new_product"
  className: "container-fluid"

  form_id: '#new_product_form'

  events:
    "submit #new_product_form": "save"
    "click .variant-selected": "variant_selected"
    "click .select-all": "select_all_variants"
    "click .picture": "add_pictures"
    "change .action": "perform_action"

  initialize: (options) ->
    @product = @options.product
    @product_variants = @options.product_variants
    @option_types = @options.option_types
    @pictures = new App.Collections.VariantsPictures
    if @product_variants.first().get('pictures_attributes')?
      for raw_picture in @product_variants.first().get('pictures_attributes')
        picture = new App.VariantsPicture
        picture.set {url: raw_picture.url, cached_path: raw_picture.cached_path}
        picture.cid = picture.get('cached_path')
        @pictures.add picture
    @translate = @options.translate.toJSON()
    @actions =
      0: { action: "remove_variants", display: @translate.delete.capitalize() }
      1: { action: "add_pictures", display: @translate.views.picture.add_pictures }


  perform_action: (e) ->
    e.preventDefault()
    e.stopPropagation()
    perform = @actions[$(e.target).val()]
    if perform != undefined
      eval "this.#{perform['action']}()"
      $('.action option:first').attr('selected','selected')


  variant_selected: (e) ->
    less_one = false
    for variant in $('.variant-selected')
      if $(variant).is(':checked')
        $(variant).checked = true
        less_one = true
    if less_one
      $("button[data-toggle='modal']").removeAttr('disabled')
    else
      $("button[data-toggle='modal']").attr('disabled', 'disabled')


  select_all_variants: (e) ->
    if $(e.target).is(':checked')
      for variant in $('.variant-selected')
        variant.checked = true
      $("button[data-toggle='modal']").removeAttr('disabled')
    else
      for variant in $('.variant-selected')
        variant.checked = false
      $("button[data-toggle='modal']").attr('disabled', 'disabled')


  remove_variants: ->
    variants = @get_variants_selected($('.variant-selected')).toArray()
    if _.isEmpty(variants)
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.product.warning.select_variants_before
        el: $('#modal .modal-body')
        mode: "alert"
      return false

    unless @product_variants.length == variants.length
      for variant in variants
        cid = variant.cid
        @product_variants.remove(variant)
        $("tr[data-cid=#{cid}]").remove()
    else
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.product.warning.product_must_have_one_variant
        el: $('#modal .modal-body')
        mode: "alert"
      return false

  get_variants_selected: (variants) ->
    variants_selected = []
    for variant in variants
      if $(variant).is(':checked')
        cid = $(variant).parents('tr').attr('data-cid')
        variants_selected.push(@product_variants.getByCid(cid))
    return new App.Collections.ProductVariants variants_selected


  update_count_pictures: (variants) ->
    master_picture = @pictures.getByCid(variants.get_master_picture())
    for variant in variants.toArray()
      $("tr[data-cid=#{variant.cid}] .picture img").attr('src', master_picture.get('url'))

  add_pictures: (e) ->
    if e?
      cid =  $(e.target).parents('tr').attr('data-cid')
      variants = new App.Collections.ProductVariants @product_variants.getByCid(cid)
    else
      variants = @get_variants_selected($('.variant-selected'))
    if variants.length == 0
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.product.warning.select_variants_before
        el: $('#modal .modal-body')
        mode: "alert"
      return false

    else
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
          picture = new App.VariantsPicture
          picture.set {url: data.url, cached_path: data.cached_name}
          picture.cid = picture.get('cached_path')
          @pictures.add picture
          @update_count_pictures(variants)
          self.view_pic.unbind() unless self.view_pic == undefined
          self.view_pic = new App.Views.Products.ProductVariantPictures(
            el: $('#pictures')
            pictures: [picture]
            variants: variants
            c_pictures: self.pictures
            master_picture: variants.get_master_picture()
          )
        ,"product_variant_picture"
        , "#pickfiles .txt"
      )
      pictures = @uniq_variants_pictures(variants)
      if pictures.length > 0
        @view_pic.unbind() unless @view_pic == undefined
        @view_pic = new App.Views.Products.ProductVariantPictures(
          el: $('#pictures')
          pictures: pictures
          variants: variants
          c_pictures: self.pictures
          master_picture: variants.get_master_picture()
        )
      $('#modal').modal('show')
      self = @
      $('#modal').on 'hide', (e) ->
        $('#modal').removeClass('modal-variants-pictures')


  uniq_variants_pictures: (variants) ->
    pictures = []
    for variant in variants.toArray()
      unless variant.get('pictures_attributes') == undefined
        for picture in variant.get('pictures_attributes')
          p = @pictures.getByCid(picture.cached_path)
          pictures.push(p) unless pictures.contains(p)
    return pictures


  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('#new_product_form input[type="submit"]').attr('disabled', 'disabled')
    @set_variants_attr($('.variants tr'))
    @product.add_variants_by_collection(@product_variants)
    @product.attributes = {product: @product.attributes}
    self = @
    App.eventsDispatcher.trigger 'startLoading'
    @product.save @product.attributes,
      success: (model, response) ->
        App.eventsDispatcher.trigger 'loadingComplete'
        new App.Views.Notice(message: self.translate.views.product.notice.created_successfully, type: 'success', size: "large" )
        $('html,body').scrollTop(0)
        window.location.hash = "#/products"
      error: (model, errors) ->
        App.eventsDispatcher.trigger 'loadingComplete'
        new App.Views.Notice(message: self.translate.views.product.error.save, type: 'error', size: "large" )
        $('html, body').scrollTop(0)
        window.location.hash = "#/products"


  set_variants_attr: (variants_dom) ->
    for variant_dom in variants_dom
      cid = $(variant_dom).attr('data-cid')
      variant = @product_variants.getByCid(cid)
      attrs =
        sku: $(variant_dom).find('input[name="product_variant[sku]"]').attr('value')
        quantity: $(variant_dom).find('input[name="product_variant[quantity]"]').attr('value')
        price: $(variant_dom).find('input[name="product_variant[price]"]').attr('value')
      variant.update_attributes(attrs)


  format_variants: ->
    variants = []
    for variant in @product_variants.models
      master_picture = variant.master_picture()
      unless master_picture == undefined
        if master_picture.picture != undefined
          master_picture = master_picture.picture.url
        else
          master_picture = "/uploads/tmp/#{master_picture.cached_path}"
      variants.push { master_picture: master_picture, cid: variant.cid, attr: variant.attributes }
    return variants


  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      option_types: @option_types.toJSON()
      product: @product.toJSON()
      product_variants: @format_variants()
      translate: @translate
      actions: @actions
    } }))
    return @
