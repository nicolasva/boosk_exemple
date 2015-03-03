class App.Contact extends Backbone.Model

  validate: (attributes) ->
    @errors = []
    if attributes?
      @errors.push "Firstname can't be empty" unless attributes.firstname isnt undefined
      @errors.push "Lastname can't be empty" unless attributes.lastname isnt undefined
    return @errors if @errors.length > 0
