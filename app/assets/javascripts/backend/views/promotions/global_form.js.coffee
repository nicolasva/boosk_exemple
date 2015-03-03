class App.Views.Promotions.GlobalForm extends Backbone.View
  template: JST['backend/templates/promotions/global_form']

  events:
    "click .generate-coupon" : "generateCouponCode"
    "click #no_end_date" : "toggleEndDate" 

  initialize: ->
    @translate = @options.translate
    App.eventsDispatcher.on "addedToDOM", @initPictureUploader, @

  render: ->
    @.$el.html(Haml.render(@template(), { locals: { model: @model, translate: @translate } }))
    $.datepicker.setDefaults($.datepicker.regional[App.locale()])
    $.timepicker.setDefaults($.timepicker.regional[App.locale()])
    @.$('#starts_at_datepicker').datetimepicker(minDate: 0, altField: "#starts_at", altFieldTimeOnly: false, altFormat: $.datepicker.ISO_8601, controlType: "select")
    @.$('#ends_at_datepicker').datetimepicker(minDate: 0, altField: "#ends_at", altFieldTimeOnly: false, altFormat: $.datepicker.ISO_8601, controlType: "select")
    @.$('#percent_discount').val(if @model.isPercentDiscount() then "1" else "0")
    return @

  generateCouponCode: ->
    code = ""
    code += Math.random().toString(36).substr(2) while code.length < 8
    @.$("#coupon_code").val(code.substr 0, 8)

  toggleEndDate: ->
    if @.$('#no_end_date').is(":checked")
      @.$('.ends_at_wrapper').hide()
      @.$('#ends_at').prop('disabled', true)
      @model.set('ends_at', null)
    else
      @.$('.ends_at_wrapper').show()
      @.$('#ends_at').prop('disabled', false)
      @.$('#ends_at').val(@model.defaults.ends_at)

  initPictureUploader: ->
    App.eventsDispatcher.off "addedToDOM"
    self = @
    new App.Libs.UploadPicture({
      browse_button: "pickpicture",
      container: "picture",
      resize:
        width: 1024
        height: 1024
        quality: 90
    }, (up, file, data) ->
      self.model.unset("picture")
      self.model.set("picture_cache", data.cached_name)
      self.$("#picture-container img").attr("src", data.url)
    , "picture", "#picture")