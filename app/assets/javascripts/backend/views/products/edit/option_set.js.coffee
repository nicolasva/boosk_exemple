App.Views.Products ||= {}
App.Views.Products.Edit ||= {}

class App.Views.Products.Edit.OptionSet extends App.Views.Products.Edit
  template: JST["backend/templates/products/edit/option_set"]

  form_id: '#edit_product_form'

  events:
    "click .variant-selected": "variant_selected"
    "click .select-all": "select_all_variants"
    "click .picture": "add_pictures"
    "change .action": "perform_action"


  initialize: (options) ->
    @product = options.product
    @product_variants = options.product_variants
    @option_types = options.option_types
    @translate = options.translate
    @pictures = options.pictures
    $("#step .step, #edit_product_form input[type='submit']").bind 'click',@,@update_variants
    @actions =
      0: { action: "add_variants", display: @translate.views.product.add_variants }
      1: { action: "remove_variants", display: @translate.delete.capitalize() }
      2: { action: "add_pictures", display: @translate.views.picture.add_pictures }
      3: { action: "set_master", display: @translate.views.product.set_master }
    @setElement(@el)
    @render()


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


  add_variants: ->
    @view = new App.Views.Products.Edi.BuildOptionSet
      product: @product
      option_types: @option_types
      product_variants: @product_variants
      translate: @translate
      pictures: @pictures
    $('#app .settings-content').html(@view.render().el)



  perform_action: (e) ->
    e.preventDefault()
    e.stopPropagation()
    perform = @actions[$(e.target).val()]
    if perform != undefined
      eval "this.#{perform['action']}()"
      $('.action option:first').attr('selected','selected')


  set_master: ->
    variants = @get_variants_selected($('.variant-selected'))
    unless variants.length == 1
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.product.warning.select_one_variant
        el: $('#modal .modal-body')
        mode: "alert"
    else
      variant = variants.first()
      $("table tr[data-cid='#{@product_variants.getMaster().cid}']").removeClass('variant-master')
      @product_variants.getMaster().set({is_master: false})
      variant.set({is_master: true})
      $("table tr[data-cid='#{variant.cid}']").addClass('variant-master')


  remove_variants: ->
    variants = @get_variants_selected($('.variant-selected')).toArray()
    if _.isEmpty(variants)
      @confirm = new App.Views.Popup
        translate: @translate
        message: @translate.views.product.warning.select_variants_before
        el: $('#modal .modal-body')
        mode: "alert"
    for variant in variants
      unless variant.is_master()
        cid = variant.cid
        variant.set { "_destroy" : "true" }
        $("tr[data-cid=#{cid}]").fadeOut 500, ->
          $("tr[data-cid=#{cid}]").remove()
      else
        @confirm = new App.Views.Popup
          translate: @translate
          message: @translate.views.product.warning.product_must_have_one_variant
          el: $('#modal .modal-body')
          mode: "alert"

  update_count_pictures: (variants) ->
    for variant in variants.toArray()
      nb_picture = $("tr[data-cid=#{variant.cid}]").find('td.nb-pictures')
      $(nb_picture).html(parseInt($(nb_picture).html()) + 1)

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
            c_pictures: self.pictures
            variants: variants
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
      unless variant.get('pictures') == undefined
        for picture in variant.get('pictures')
          if picture._destroy == undefined
            p = @pictures.getByCid(picture.cached_path)
            pictures.push(p) unless pictures.contains(p)
    return pictures


  get_variants_selected: (variants) ->
    variants_selected = []
    for variant in variants
      if $(variant).is(':checked')
        cid = $(variant).parents('tr').attr('data-cid')
        variants_selected.push(@product_variants.getByCid(cid))
    return new App.Collections.ProductVariants variants_selected


  update_variants: (e) =>
    @set_variants_attr($('.variants tr'))


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


  set_variants_attr: (variants_dom) ->
    for variant_dom in variants_dom
      cid = $(variant_dom).attr('data-cid')
      variant = @product_variants.getByCid(cid)
      attrs =
        sku: $(variant_dom).find('input[name="product_variant[sku]"]').attr('value')
        quantity: $(variant_dom).find('input[name="product_variant[quantity]"]').attr('value')
        price: $(variant_dom).find('input[name="product_variant[price]"]').attr('value')
      variant.update_attributes(attrs)


  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      product: @product.toJSON()
      option_types: @option_types.toJSON()
      product_variants: @format_variants()
      translate: @translate
      actions: @actions
    } }))
    $("table tr[data-cid='#{@product_variants.getMaster().cid}']").addClass('variant-master')
    return @
