$("button, input[type=submit], a").live 'click',  ->
  $('input[placeholder], textarea[placeholder]').placeholder()

$("input[type=submit]").live 'click', ->
  $(".necessary.error-empty").each ->
    $(this).removeClass('error-empty')
  token = true
  current_form = $(this).closest('form')[0]
  $(".necessary").each ->
    if $(this).hasClass('select2-container')
      select = $(this).next()
      if $(select).val() == '' and $(select).closest('form')[0] == current_form
        token = false
        $(this).addClass('error-empty')
    else if $(this).val() == '' and $(this).closest('form')[0] == current_form
      token = false
      $(this).addClass('error-empty')
  $(".email").each ->
    unless $(this).val() == ''
      unless /^.+@.+\..+$/.test($(this).val())
        if $(this).closest('form')[0] == current_form
          token = false
          $(this).addClass('error-empty')
  $(".url").each ->
    unless $(this).val() == ''
      unless /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w\#!:.?+=&%@!\-\/]))?/.test($(this).val())
        $(this).attr("value", "http://"+$(this).val())
  $(".number").each ->
    unless $(this).val() == ''
      $(this).attr('value', $(this).val().replace(',','.').replace(' ', ''))
      unless !isNaN(parseFloat($(this).val())) && isFinite($(this).val())
        if $(this).closest('form')[0] == current_form
          token = false
          $(this).addClass('error-empty')
  $(".price,.pos-num").each ->
    unless $(this).val() == ''
      $(this).attr('value', $(this).val().replace(',','.').replace(' ', ''))
      unless !isNaN(parseFloat($(this).val())) && isFinite($(this).val()) && parseFloat($(this).val()) > 0
        if $(this).closest('form')[0] == current_form
          token = false
          $(this).addClass('error-empty')  
  return token
