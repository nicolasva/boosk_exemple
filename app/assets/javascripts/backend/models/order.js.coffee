class App.Order extends Backbone.Model
  idAttribute: "number"

  url: ->
    base = "/shops/#{App.current_shop}/orders"
    return base if @isNew()
    base + "/#{@id}"

  validate: (attributes) ->
    "Error!" unless attributes


Backbone.Model.prototype.change_status = (model, status, options) ->
  throw new Error('Should pass ids') if _.isEmpty(model)
  success = options.success;

  options.success = (resp) =>
    triggerDestroy() if options.wait
    if success
      success(model, resp)
    else
      @.trigger('sync', model, resp, options)

  options.error = Backbone.wrapError(options.error, model, options)

  params =
    type: 'PUT'
    dataType: 'json'

  params.data = {status: status}

  params.url = @url()

  $.ajax(_.extend(params, options))
