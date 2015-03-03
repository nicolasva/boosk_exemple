String.prototype.scan = (regex) ->
  r = new Array()
  this.replace(regex, ->
    r.push(Array.prototype.slice.call(arguments, 1, -2))
  )
  return r
