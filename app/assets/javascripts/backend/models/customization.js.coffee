class App.Customization extends Backbone.Model
  validate: (attributes) ->
    "Error!" unless attributes

  updateAttachmentAttributes: (attachment_type, new_attrs) ->
    attachment_attrs = @get("#{attachment_type}_attributes")
    attachment_attrs or= {}
    attachment_attrs["id"] = @get("#{attachment_type}").id
    #merge of the old attributes with the new ones
    for key, val of new_attrs
      attachment_attrs[key] = val
    #update of the backbone model
    @set("#{attachment_type}_attributes", attachment_attrs)