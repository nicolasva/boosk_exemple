$(document).ready ->
  $('.alert').click (e) -> $('.alert').hide()
  setTimeout =>
      $('.alert').fadeOut()
    , 5000

  $('#header-login a').popover(
    placement: 'bottom'
    html : true
    content: (e) ->
      return $('.sign-in').html()
  )
  params = getUrlVars()
  $('.sign-up #user_lastname').attr('value', decodeURIComponent(params['lastname'])) if params['lastname'] != undefined
  $('.sign-up #user_firstname').attr('value', decodeURIComponent(params['firstname'])) if params['firstname'] != undefined
  $('.sign-up #user_email').attr('value', params['email']) if params['email'] != undefined
  $('.sign-up #user_shop_key').attr('value', params['shop_key']) if params['shop_key'] != undefined
  if params['have_coupon'] != undefined
    $('.sign-up #have_coupon').attr('value', params['have_coupon'])
    $('#fb-login').attr('href', "#{$('#fb-login').attr('href')}?have_coupon=true")
  if params['without_cb'] != undefined
    $('#fb-login').attr('href', "#{$('#fb-login').attr('href')}?without_cb=true")
    $('.sign-up #without_cb').attr('value', params['without_cb'])

