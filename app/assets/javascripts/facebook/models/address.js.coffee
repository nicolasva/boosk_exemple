class App.Address extends Backbone.Model
  defaults: 
    firstname: ""
    lastname: ""
    mail: "" 
    addr: ""
    designation: ""
    zip_code: ""
    city: ""

  validate: (attributes) ->
    @errors = [] 
    if attributes.address? 
      @errors.push "Firstname can't be empty" unless attributes.address.firstname? and attributes.address.firstname isnt ""
      @errors.push "Lastname can't be empty" unless attributes.address.lastname and attributes.address.lastname isnt ""
      @errors.push "Address can't be empty" unless attributes.address.addr and attributes.address.addr isnt ""
      @errors.push "Zip_code can't be empty" unless attributes.address.zip_code? and attributes.address.zip_code isnt ""
      @errors.push "City can't be empty" unless attributes.address.city? and attributes.address.city isnt ""
      @errors.push "Country can't be empty" unless attributes.address.country? and attributes.address.country isnt ""
      @errors.push "State can't be empty" unless attributes.address.state? and attributes.address.state isnt ""
    else
      @errors.push "Firstname can't be empty" unless attributes.firstname? and attributes.firstname isnt ""
      @errors.push "Lastname can't be empty" unless attributes.lastname? and attributes.lastname isnt ""
      @errors.push "Address can't be empty" unless attributes.address? and attributes.address isnt ""
      @errors.push "Zip_code can't be empty" unless attributes.zip_code? and attributes.zip_code isnt ""
      @errors.push "City can't be empty" unless attributes.city? and attributes.city isnt ""
      @errors.push "Country can't be empty" unless attributes.country? and attributes.country isnt ""
      @errors.push "State can't be empty" unless attributes.state? and attributes.state isnt ""
    return @errors if @errors.length > 0
