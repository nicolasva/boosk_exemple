class App.Views.Products.ChangeOptionTypes extends Backbone.View
  el: "#option-types"

  variant_selected: null

  template: JST["mobile/templates/products/change_variant_options"]

  initialize: (options) ->
    @translate = options.translate
    @option_types = options.option_types
    @variant_option_types = options.variant_option_types
    @product_variants = options.product_variants
    @save_options_selected = options.save_options_selected
    @unselectable = []
    @target = options.target
    @setElement(@el)
    @render()

  render: ->
    @process_options()
    $(@el).html(Haml.render(@template(), { locals: {
      shop_option_types: @option_types.toJSON()
      variant_option_types: @variant_option_types
      selected: @save_options_selected
      options_unselectable: @unselectable
      translate: @translate.toJSON()
    }}))

  process_options: ->
    id = $(@target).attr('value')
    current_target_opts = []

    if isNaN(id)
      for t in @save_options_selected
        @save_options_selected.splice(0, 1)
    else
      for option_type in $(@target).find('option')
        current_target_opts.push parseInt($(option_type).attr('value'))

      i = 0

      for save_option in @save_options_selected
        if _.include(current_target_opts, parseInt(save_option))
          @save_options_selected.splice(i, 1)
        i++

      @save_options_selected.push parseInt(id) if parseInt(id)

      option_types_dom = $("#option-types select")

    if @save_options_selected.length > 0
      @variant_selected = @product_variants.findByOptionTypes(@save_options_selected)[0]
      @unselectable = @product_variants.check_unselectable(
        @save_options_selected,
        option_types_dom
      )
    else
      @variant_selected = @product_variants.getMaster()


