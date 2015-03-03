class App.ProductOptionType extends Backbone.Model
  url: ->
    base = "/shops/#{App.current_shop}/option_types"
    return base  if @isNew()
    base + (if base.charAt(base.length - 1) is "/" then "" else "/") + @id


  validate: (attributes) ->
    @errors ||= []
    if attributes.option_type != undefined
      @errors.push "Name can't be blank!" unless attributes.option_type.name
      if attributes.option_type.option != undefined
        @errors.push "Value can't be blank!" unless attributes.option_type.option.length > 0
      else
        @errors.push "Value can't be blank!" unless attributes.option_type.value.length > 0
      @errors.push "Key already exist!" if @.collection.key_exist(attributes.option_type.name, @)
    return true if @errors.length > 0


  parse: (option_type) ->
    option_type.id = option_type.type unless option_type == undefined or option_type.type == undefined
    return option_type

