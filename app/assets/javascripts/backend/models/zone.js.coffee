class App.Zone extends Backbone.Model
  defaults:
    name: ""
    zone_members_codes: []

  url: ->
    base = "/shops/#{App.current_shop}/zones"
    return base  if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id

  validate: (attributes) ->
    errors = []
    if not attributes.name? or attributes.name is ""
      errors.push "Name can't be blank"
    else if @collection and @collection.alreadyExists(attributes.name, attributes.id)
      errors.push "Name is already taken"
    return errors if errors.length
