App.Views.Products ||= {}
class App.Views.Products.ProductVariantPictures extends Backbone.View
  template: JST["backend/templates/products/_product_variant_pictures"]

  events:
    "click .remove,.remove-master": "delete_picture"
    "mouseover .primary .picture": "show_primary_destroy"
    "mouseout .primary .picture": "hide_primary_destroy"

  initialize: (options) ->
    @translate = new App.Translate
    @variants = options.variants
    @master_picture = options.master_picture
    @carousel = options.carousel
    self = @
    @translate.fetch
      success: ->
        self.render()
        self.set_droppable_primary()
        self.set_draggable_pictures()


  show_primary_destroy: ->
    $('.overlay').show()
    $(".remove-master").show()

  hide_primary_destroy: ->
    $('.overlay').hide()
    $(".remove-master").hide()

  delete_picture: (e) ->
    e.preventDefault()
    e.stopPropagation()
    picture = $(e.target).parent('.picture')
    cached_name = $(picture).attr('data-cached-name')
    if $(picture).attr('data-primary') is "y"
      if $('.picture[data-primary="n"]').length > 0
        new_master = $('.picture[data-primary="n"]').first()
        $(picture).attr('data-cached-name', $(new_master).attr('data-cached-name'))
        $(picture).find('img').attr('src', $(new_master).find('img').attr('src'))
        if $('#zone-pictures .master').length > 0
          $('#zone-pictures .master').find('img').attr('src', $(new_master).find('img').attr('src'))
          src = $(new_master).find('img').attr('src')
          $('#zone-pictures .variants-pictures').find("img[src='#{src}']").parent('.variant').remove()
        @variants.change_master_picture($(new_master).attr('data-cached-name'))
        $(new_master).fadeOut 500, ->
          $(new_master).remove()
      else
        $(picture).parent('.primary').fadeOut 500, ->
          $(picture).parent('.primary').remove()
        if $('#zone-pictures .master').length > 0
          $('#zone-pictures .master').find('img').remove()
    else
      $(picture).fadeOut 500, ->
        $(picture).remove()
      if $('#zone-pictures .master').length > 0
        src = $(picture).find('img').attr('src')
        $('#zone-pictures .variants-pictures').find("img[src='#{src}']").parent('.variant').remove()
        @carousel.remove_item() if @carousel != undefined


    variants_d = @variants.destroy_picture(cached_name)

    if $('tbody.variants .nb-pictures').length > 0
      master_picture = @options.c_pictures.getByCid(@variants.get_master_picture())
      cids = _.map variants_d, (v) ->
        return v.cid
      for cid in cids
        if master_picture?
          $("tr[data-cid=#{cid}] .picture img").attr('src', master_picture.get('url'))
        else
          $("tr[data-cid=#{cid}] .picture img").attr('src', App.default_product_picture_url)

  set_droppable_primary: ->
    self = @
    $(".primary").droppable
      drop: (event, ui ) ->
        picture = $(ui.draggable)
        src = $(picture).find('img').attr('src')
        if $('#zone-pictures .master').length > 0
          $('#zone-pictures .master').find('img').attr('src', $(picture).find('img').attr('src'))
          img = $('#zone-pictures .variants-pictures').find("img[src='#{src}']")
          $(img).attr('src', $(@).find('img').attr('src'))

        if $('tbody.variants .nb-pictures').length > 0
          cids = _.map self.variants.models, (v) ->
            return v.cid
          for cid in cids
            $("tr[data-cid=#{cid}] .picture img").attr('src', src)

        draggable_name = $(picture).attr('data-cached-name')
        droppable_name = $(@).find('.picture').attr('data-cached-name')
        droppable_src = $(@).find('.picture img').attr('src')

        $(@).find('.picture img').attr('src', src)
        $(picture).find('img').attr('src', droppable_src)

        $(@).find('.picture').attr('data-cached-name', draggable_name)
        $(picture).attr('data-cached-name', droppable_name)

        self.variants.change_master_picture(draggable_name)



  set_draggable_pictures: ->
    $(".picture").draggable
      revert: true


  render: ->
    for picture in @options.pictures
      if @variants.first().get('pictures')?
          pictures = _.reject @variants.first().get('pictures'), (pic) ->
            return pic['_destroy'] != undefined
      else
        pictures = @variants.first().get('pictures_attributes')
      if picture?
        if pictures.length == 1 or picture.get('cached_path') == @master_picture
          $(@el).prepend(Haml.render(@template(), {
            locals: {
              translate: @translate.toJSON()
              url: picture.get('url') or picture.get('picture').url
              cached_path: picture.get('cached_path')
              is_master: true }
          }))
        else
          $('#pickfiles').before(Haml.render(@template(), { locals: {
            translate: @translate.toJSON()
            url: picture.get('url') or picture.get('picture').url
            cached_path: picture.get('cached_path')
            is_master: false }}))
      $('.modal-body').animate({scrollTop: 1000000}, 800)
    return @

  unbind: ->
    $(@el).unbind()
