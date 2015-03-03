#= require jquery
#= require_self

ismobile = ((if navigator.userAgent.match(/iphone|ipod|ipad|android|iemobile|nokia|webos/i) then true else false))

if ismobile
  if typeof shop_key isnt "undefined" and shop_key isnt null
    $.ajax
      dataType: 'json'
      url:  "http://shops.boosket.com/shops/#{shop_key}.json"
      success: (s) ->
        if s.mobile_status
          window.location = "http://#{s.slug}.boosketshop.com/mobile/#/shops/#{s.uuid}"
      error: (s) ->
        console.log s
