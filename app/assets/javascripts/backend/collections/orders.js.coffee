class App.Collections.Orders extends Backbone.Collection
  model: App.Order

  change_status_url: ->
    "/shops/#{App.current_shop}/orders/update/all"

  url: ->
    "/shops/#{App.current_shop}/orders"


Backbone.Collection.prototype.change_status = (models, status, options) ->
  throw new Error('Should pass ids') if _.isEmpty(models)
  success = options.success;

  options.success = (resp) =>
    triggerDestroy() if options.wait
    if success
      success(models, resp)
    else
      @.trigger('sync', models, resp, options)

  options.error = Backbone.wrapError(options.error, models, options)

  params =
    type: 'PUT'
    dataType: 'json'

  model_ids = []
  for model in models
    model_ids.push model.get('id')

  params.data = {ids: model_ids, status: status}

  params.url = @.change_status_url()

  $.ajax(_.extend(params, options))
