class App.Views.Products.Show extends Backbone.View

  template: JST["backend/templates/products/show"]

  initialize: (options) ->
    @product_variants = @options.product_variants
    @product = @options.product
    @option_types = @options.option_types
    @variant_option_types = @product_variants.getOptionTypes()
    @variant = @product_variants.getMaster()
    @save_options_selected = new Array


  events:
    "click .destroy": "destroy"
    "change .change-variants": "change_variants"


  destroy: (event) ->
    App.eventsDispatcher.trigger 'startLoading'
    id= $(event.target).attr('data-id')
    product_variant = @product_variants.get(id)
    product_variant.destroy
      success: (data, reponse) ->
        $(event.target).parent('.product').remove()
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  change_variants: (event) ->
    id = $(event.target).attr('value')
    $(event.target).addClass('current-selected')
    current_target_opts = new Array
    unselectable = new Array

    for option_type in $(event.target).find('option')
      current_target_opts.push parseInt($(option_type).attr('value'))

    i = 0
    for save_option in @save_options_selected
      if current_target_opts.contains(parseInt(save_option))
        @save_options_selected.splice(i, 1)
      i++
    @save_options_selected.push parseInt(id) if parseInt(id)
    option_types_dom = $(".change-variants").not('.current-selected')

    if @save_options_selected.length > 0
      variant = @product_variants.findByOptionTypes(@save_options_selected)[0]
      unselectable = @product_variants.check_unselectable(
        @save_options_selected,
        option_types_dom
      )
    else
      variant = @variant

    $(event.target).removeClass('current-selected')

    @view = new App.Views.Products.ShowVariants(
      variant: variant,
      unselectable: unselectable,
      option_types: @option_types,
      variant_option_types: @variant_option_types,
      selected: @save_options_selected,
      product: @product
    )

    $("#variants").html(@view.render().el)



  render: ->
    $(@el).html(Haml.render(@template(), { locals: {
      product: @product.toJSON(),
      variant: @variant.toJSON(),
      option_types: @option_types.toJSON(),
      variant_option_types: @variant_option_types
      }}))
    return @
