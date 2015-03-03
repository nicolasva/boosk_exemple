class App.Views.Products.Import extends Backbone.View
  template: JST["backend/templates/products/import"]

  el: "#modal"

  events:
    "click #upload-file": "upload"

  initialize: (options) ->
    @translate = options.translate
    @render()
    @init_upload()

  upload: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @upload_csv.uploader.start()

  init_upload: ->
    @upload_csv = new App.Libs.UploadCsv({
      browse_button: 'pickfiles',
      container: 'container',
      }, (up, files) =>
        $('#import-products .file').html(files[0].name)
      , (up, file, data) =>
        $('#import-products').fadeOut ->
          $('#success-import').fadeIn()
      ,"csv"
      , "#pickfiles .file"
    )

  render: ->
    $('#modal').addClass('modal-import-products')
    $('#modal .modal-header h3').html(@translate.views.product.import_by_csv)
    $(@el).find('.modal-body').html(Haml.render(@template(), { locals: {
      translate: @translate      
    }}))
    $('#modal').modal('show')
    $('#modal').on 'hide', (e) ->
      $('#modal').removeClass('modal-import-products')
