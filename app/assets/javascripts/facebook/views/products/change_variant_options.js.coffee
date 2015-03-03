class App.Views.Products.ChangeVariantOptions extends Backbone.View
  el: '#option-types'

  template: JST["facebook/templates/products/change_variant_options"]

  initialize: (options) ->
    @translate = options.translate
    @option_types = options.option_types
    @variant_option_types = options.variant_option_types
    @product_variants = options.product_variants
    @save_options_selected = options.save_options_selected
    @target = options.target
    @variant_selected = null
    @process_options()

  process_options: ->
    id = $(@target).attr('value')
    $(@target).addClass('current-selected')
    current_target_opts = []
    @unselectable = []

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

    $(@target).removeClass('current-selected')

    @render()

  update_quantity: ->
    $('#quantity select').html('')
    if parseInt(@variant_selected.get('quantity')) <= 0
      $('#quantity select').attr('disabled', 'disabled')
      $("#add_to_cart input[type=submit]").attr("disabled", "disabled")
    else
      for r in _.range(1, parseInt(@variant_selected.get('quantity') + 1))
        $('#quantity select').append("<option value='#{r}'>#{r}</option>")
      $('#quantity select').removeAttr('disabled')
      $("#add_to_cart input[type=submit]").removeAttr("disabled")

  render: ->
    @update_quantity()

    if @save_options_selected.length == $("#option-types select").length and parseInt(@variant_selected.get('quantity')) > 0
      $("#add_to_cart input[type=submit]").removeAttr("disabled")
    else
      $("#add_to_cart input[type=submit]").attr("disabled", "disabled")

    $(@el).html(Haml.render(@template(), { locals: {
      shop_option_types: @option_types.toJSON()
      variant_option_types: @variant_option_types
      selected: @save_options_selected
      options_unselectable: @unselectable
      translate: @translate.toJSON()
    }}))


  close: ->
    $(@el).unbind()
    $(@el).empty()