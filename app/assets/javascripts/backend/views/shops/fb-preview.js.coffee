class App.Views.Shops.FB_Preview extends Backbone.View
  el: '#modal'
  template: JST["backend/templates/shops/fb_preview"]

  events:
    "click #tab_facebook" : "click_facebook"
    "click #tab_mobile" : "click_mobile"

  initialize: ->
    $('#shop-preview').live 'click', @, (e) =>
      $('#shop-preview').popover('hide')
      @render()

    $('#shop-preview').popover()

  render: ->
    shop = App.shop(App.current_shop).toJSON()
    url = "#{window.location.protocol}//#{shop.slug}.#{window.location.host}/facebook/?preview=true#/shops/#{shop.uuid}"
    url_mobile = "#{window.location.protocol}//#{shop.slug}.#{window.location.host}/mobile/?preview=true#/shops/#{shop.uuid}"
    $(@el).addClass("modal-fb-preview facebook")
    $(@el).removeClass("mobile")
    $(@el).find(".modal-header h3").hide()
    self = @
    $(@el).on 'hide', (e) ->
      $(self.el).removeClass('modal-fb-preview mobile facebook')
      $(self.el).find(".modal-header h3").show()
    $(@el).find('.modal-body').html(Haml.render(@template(), { locals: { url:url, url_mobile:url_mobile} }))
    $(@el).modal('show')
    $(@el).find('iframe').css("height", "#{$(window).height() - 100}px")
    App.eventsDispatcher.trigger 'startLoading'
    $('body').keyup (e) ->
      if e.keyCode == 27
        App.eventsDispatcher.trigger 'loadingComplete'
        $('body').unbind("keyup")
    $("#iframe_facebook").load ->
      App.eventsDispatcher.trigger 'loadingComplete'
      $('body').unbind("keyup")

  click_facebook: ->
    $(@el).addClass("facebook")
    $(@el).removeClass("mobile")

  click_mobile: ->
    $(@el).addClass("mobile")
    $(@el).removeClass("facebook")
