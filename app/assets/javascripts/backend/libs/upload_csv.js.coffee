class App.Libs.UploadCsv extends Backbone.View

  defaults_options:
    runtimes : 'html5,flash,silverlight'
    filters : [
      { title : "Image files", extensions : "csv" }
    ]
    flash_swf_url: '/assets/plupload.flash.swf'
    silverlight_xap_url: '/assets/plupload.silverlight.xap'

  initialize: (options, callback_added, callback_uploaded,attachment_type = "csv", spinner_container) ->
    @callback_added = callback_added
    @callback_uploaded = callback_uploaded
    @options = @deepExtend(@options, @defaults_options)
    @options.multipart_params=
      authenticity_token: $("#token").attr('value'),
      '_boosket-shop_session': $("#session-key-value").attr('value'),
      attachment_type: attachment_type
    @options.url = "/shops/#{App.getCookie('shop_id')}/products/import_by_upload"
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
    @callback_added(up, files)

  file_uploaded: (up, file, call) =>
    data = $.parseJSON(call.response)
    @callback_uploaded(up, file, data)

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

