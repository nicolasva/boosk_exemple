$(document).ready ->
  counter_value = 0
  $("#new_option_type_form #add_values").live "click", (e) ->
    el = $(event.target).parent('.option_type_value_row').clone()
    $(el).find('label').remove()
    $(event.target).remove()
    counter_value++
    $(el).find('input').attr("id", "option_type_value_#{counter_value}")
    $(el).find('input').attr("value", "")
    $('.values-area').append(el)

  $("#edit_option_type_form #add_values").live "click", (e) ->
    if $('.option_type_value_row').length > 0
      counter_value = parseInt($('.option_type_value_row').length - 1)
    else
      counter_value = 0
    el = $(e.target).parent('.option_type_value_row').clone()
    $(el).find('label').remove()
    $(e.target).remove()
    counter_value++
    $(el).find("input[type='hidden']").remove()
    $(el).find('input').attr("value", "")
    $('.values-area').append(el)
