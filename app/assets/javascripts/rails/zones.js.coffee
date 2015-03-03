$(document).ready ->
  $(".chzn-select").chosen()

  $("#zones-list .action").change (e) ->
    e.preventDefault()
    e.stopPropagation()
    if $(e.target).val() is "destroy"
      zones = $('.zone-selected:checked').map () ->
        $(@).parents('tr').attr('data-id')
      .get()
      if zones.length == 0
        alert "Select Zone(s) before"
      else
        $.ajax
          type: 'DELETE'
          dataType: "json"
          url: "/shops/#{App.current_shop}/zones/destroy/all"
          data: {ids: zones}
          success: () ->
            for zone in zones
              $("tr[data-id=#{zone}]").fadeOut 500, ->
                $(@).remove()
      $('.action option:first-child').attr('selected','selected')

  $("#zones-list .select-all").click (e) ->
    $('.zone-selected').attr 'checked', $(e.target).is(':checked')