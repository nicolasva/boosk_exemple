App.Libs ||= {}
class App.Libs.UploadPicture extends Backbone.View

  defaults_options:
    runtimes : 'html5,flash,silverlight'
    max_file_size: '15mb'
    filters : [
      { title : "Image files", extensions : "jpg,jpeg,gif,png" }
    ]
    flash_swf_url: '/assets/plupload.flash.swf'
    silverlight_xap_url: '/assets/plupload.silverlight.xap'
    multipart: true
    url: '/attachments.js'

  initialize: (options, callback, attachment_type = "product_variant_picture", spinner_container) ->
    @callback = callback
    @options = @deepExtend(@options, @defaults_options)
    @options.multipart_params=
      authenticity_token: $("#token").attr('value'),
      '_boosket-shop_session': $("#session-key-value").attr('value'),
      attachment_type: attachment_type
    @uploader = new plupload.Uploader(@options)
    @uploader.init()
    @uploader.bind('FilesAdded', @file_added)
    @uploader.bind('FileUploaded', @file_uploaded)
    if spinner_container?
      @uploader.bind 'BeforeUpload', () ->
        $(spinner_container).addClass("loading-picture")
      @uploader.bind 'FileUploaded', () ->
        $(spinner_container).removeClass("loading-picture")
      @uploader.bind 'Error', () ->
        $(spinner_container).removeClass("loading-picture")

  file_added: (up, files) =>
    @uploader.start()

  file_uploaded: (up, file, call) =>
    data = $.parseJSON(call.response)
    @callback(up, file, data)

  deepExtend: (object, extenders...) ->
    return {} if not object?
    for other in extenders
      for own key, val of other
        if not object[key]? and $.isArray(val)
          object[key] = val
        else if not object[key]? and typeof val isnt "object"
          object[key] = val
        else
          object[key] = @deepExtend object[key], val
    object

