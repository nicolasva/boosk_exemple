App.getCookie = (name) ->
  result = ""
  regSepCookie = new RegExp('(; )', 'g')
  cookies = document.cookie.split(regSepCookie)
  i = 0
  while i < cookies.length
    regInfo = new RegExp('=', 'g')
    infos = cookies[i].split(regInfo)
    if infos[0] == name
      result = unescape(infos[1])
    i += 1
  result

App.setCookie = (c_name, value) ->
  exdate = new Date()
  exdate.setDate(exdate.getDate() + 1)
  cookie = c_name+"="+value+";expires="+exdate.toUTCString()
  document.cookie = cookie

App.delCookie = (name) ->
  document.cookie = name + "=; expires=Thu, 01-Jan-70 00:00:01 GMT;"

App.current_shop = App.getCookie("shop_id")
App.current_shop_devise = App.getCookie("shop_devise")
