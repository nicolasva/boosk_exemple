App.Views.ProductOptionTypes ||= {}

class App.Views.ProductOptionTypes.Edit extends Backbone.View
  template: JST["backend/templates/product_option_types/edit"]

  form_id: '#edit_option_type_form'

  events:
    "submit #edit_option_type_form": "update"
    "click  .add_values": "input_value"
    "click  .remove_value": "remove_input_value"

  initialize: (options) ->
    @translate = @options.translate

  update: (e) =>
    e.preventDefault()
    e.stopPropagation()
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @model.save($(@form_id).toJSON(),
      success: (option_type, response) ->
        App.eventsDispatcher.trigger 'loadingComplete'
        self.model.set response[0]
        self.model.set(id: self.model.get('type'))
        if $(self.options.modal).length > 0
          $(self.options.modal).modal('hide')
        else
          window.location.hash = "#/option_types"
      error: (option_type, errors) =>
        App.eventsDispatcher.trigger 'loadingComplete'
        if typeof errors == 'object'
          errors_json = jQuery.parseJSON(errors.responseText)
        new App.Views.Notice
          message: option_type.errors,
          type: 'error',
          el: '#notice-modal'
        delete option_type.errors
        option_type.change()
    )


  input_value: (e) =>
    if $('.option_type_value_row').length > 0
      counter_value = parseInt($('.option_type_value_row').length - 1)
    else
      counter_value = 0
    el = $(e.target).parent('.option_type_value_row').clone()
    $(el).find('label').remove()
    $(el).find('span.need').remove()
    counter_value++
    $(e.target).hide()
    $(el).css("margin-left", "-35px")
    $(el).find('.remove_value').css('display', 'inline-block')
    $(el).find("input[type='hidden']").remove()
    $(el).find('input').attr("name", "option_type[option][#{counter_value}][value]")
    $(el).find('input').attr("value", "")
    $('.values-area').append(el)

  remove_input_value: (event) ->
    el = $(event.target).parent('.option_type_value_row')
    if $(el).find('.add_values').is(':visible')
      $(el).prev().find('.add_values').css('display', 'inline-block')
    $(el).remove()


  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      option_type: @model.toJSON(),
      translate: @translate
    } }))
    return this
