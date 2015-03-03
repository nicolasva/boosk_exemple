App.Views.Products ||= {}

class App.Views.ProductOptionTypes.New extends Backbone.View
  template: JST["backend/templates/product_option_types/new"]

  form_id: '#new_option_type_form'

  events:
    "submit #new_option_type_form": "save"
    "click  .add_values": "add_input_value"
    "click  .remove_value": "remove_input_value"

  initialize: (options) ->
    @counter_value = 0
    @translate = @options.translate

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @collection.create($(@form_id).toJSON(),
      wait: true,
      success: (option_type, response) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        self.collection.remove(option_type)
        option_type = new App.ProductOptionType(response[0])
        option_type.set(id: option_type.get('type'))
        self.collection.add(option_type)
        if $(self.options.modal).length > 0
          $(self.options.modal).modal('hide')
        else
          window.location.hash = "#/option_types"
      error: (option_type, errors) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        if typeof errors == 'object'
          errors_json = jQuery.parseJSON(errors.responseText)
        new App.Views.Notice(message: option_type.errors, type: 'error', el: '#notice-modal' )
        delete option_type.errors
        option_type.change()
    )


  add_input_value: (event) ->
    el = $(event.target).parent('.option_type_value_row').clone()
    $(el).find('label').parent().parent().parent().parent().remove()
    $(event.target).hide()
    @counter_value++
    $(el).css("margin-left", "-35px")
    $(el).find('.remove_value').css('display', 'inline-block')
    $(el).find('input').attr("id", "option_type_value_#{@counter_value}")
    $(el).find('input').attr("name", "option_type[value][]")
    $(el).find('input').attr("value", "")
    $('.values-area').append(el)
    $(el).find('input').focus()


  remove_input_value: (event) ->
    el = $(event.target).parent('.option_type_value_row')
    if $(el).find('.add_values').is(':visible')
      $(el).prev().find('.add_values').css('display', 'inline-block')
    $(el).remove()

  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      translate: @translate
    } }))
    return this
