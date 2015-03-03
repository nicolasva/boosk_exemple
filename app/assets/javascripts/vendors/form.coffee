(($) ->
  $.fn.toJSON = (options) ->
    options = $.extend({}, options)
    self = this
    json = {}
    push_counters = {}
    patterns =
      validate: /^[a-zA-Z][a-zA-Z0-9_]*(?:\[(?:\d*|[a-zA-Z0-9_]+)\])*$/
      key: /[a-zA-Z0-9_]+|(?=\[\])/g
      push: /^$/
      fixed: /^\d+$/
      named: /^[a-zA-Z0-9_]+$/

    @build = (base, key, value) ->
      base[key] = value
      base

    @push_counter = (key) ->
      push_counters[key] = 0  if push_counters[key] is `undefined`
      push_counters[key]++

    $.each $(this).serializeArray(), ->
      return  unless patterns.validate.test(@name)
      k = undefined
      keys = @name.match(patterns.key)
      merge = @value
      reverse_key = @name
      while (k = keys.pop()) isnt `undefined`
        reverse_key = reverse_key.replace(new RegExp("\\[" + k + "\\]$"), "")
        if k.match(patterns.push)
          merge = self.build([], self.push_counter(reverse_key), merge)
        else if k.match(patterns.fixed)
          merge = self.build([], k, merge)
        else merge = self.build({}, k, merge)  if k.match(patterns.named)
      json = $.extend(true, json, merge)

    json
) jQuery
