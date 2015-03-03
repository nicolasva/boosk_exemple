height = (section) ->
  if typeof(window.innerWidth) == 'number'
    height = window.innerHeight
  else if document.documentElement && document.documentElement.clientHeight
    height = document.documentElement.ClientHeight

  $(section).css("height", height+"px")

$(document).ready ->
  if typeof(window.innerWidth) == 'number'
    height = window.innerHeight
  else if document.documentElement && document.documentElement.clientHeight
    height = document.documentElement.ClientHeight

  $('.corps').css("height", height+"px")
  $(window).bind 'orientationchange', ->
    if typeof(window.innerWidth) == 'number'
      height = window.innerHeight
    else if document.documentElement && document.documentElement.clientHeight
      height = document.documentElement.ClientHeight

    $('.corps').css("height", height+"px")

$(window).resize ->
  if typeof(window.innerWidth) == 'number'
    height = window.innerHeight
  else if document.documentElement && document.documentElement.clientHeight
    height = document.documentElement.ClientHeight

  $('.corps').css("height", height+"px")

$(window).load ->
  if typeof(window.innerWidth) == 'number'
    height = window.innerHeight
  else if document.documentElement && document.documentElement.clientHeight
    height = document.documentElement.ClientHeight


    $('.corps').css("height", height+"px")

