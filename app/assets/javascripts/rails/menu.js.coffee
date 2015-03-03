$(document).ready ->
  $("#add-item").click () ->
    $("#menu-container").jstree("create")

  $("#rename-item").click () ->
    $("#menu-container").jstree("rename")

  $("#destroy-item").click () ->
    $("#menu-container").jstree("remove")

  $("#menu-container").jstree
    core:
      initially_open:[ "menu-root" ]
    themes:
      theme: "boosket"
      icons: false
    ui:
      select_limit: 1
      selected_parent_close: "deselect"
      select_prev_on_delete: false
      initially_select: [ "menu-root" ]
    types:
      max_depth: -2
      max_children: -2
      types:
        home:
          valid_children: "none"
          start_drag: false
          move_node: false
          delete_node: false
          remove: false
          select_node: false
        root:
          start_drag: false
          move_node: false
          delete_node: false
          remove: false
    plugins: [ "themes", "html_data", "ui", "crrm", "dnd", "types" ]
  .on("create.jstree", (e, data) ->
    name = data.rslt.name
    position = data.rslt.position
    parent_id = if data.rslt.parent is -1 then $("#menu-root").data("id") else data.rslt.parent.data("id")
    position-- if parent_id is $("#menu-root").data("id")
    taxonomy_id = $("#menu-container").data("taxonomy_id")
    $.ajax
      type: "POST"
      dataType: "json"
      url: "/shops/#{App.current_shop}/taxonomies/#{taxonomy_id}/taxons"
      data:
        taxon:
          name: name
          parent_id: parent_id
          position: position
      success: (response) ->
        $(data.rslt.obj).data("id", response.id)
        updatePreview()
      error: ->
        $.jstree.rollback(data.rlbk)
  )
  .on("rename.jstree", (e, data) ->
    taxonomy_id = $("#menu-container").data("taxonomy_id")
    taxon_id = $(data.rslt.obj).data("id")
    $.ajax
      type: "PUT"
      dataType: "json"
      url: "/shops/#{App.current_shop}/taxonomies/#{taxonomy_id}/taxons/#{taxon_id}"
      data:
        taxon:
          name: data.rslt.new_name
      success: ->
        updatePreview()
      error: ->
        $.jstree.rollback(data.rlbk)
  )
  .on("remove.jstree", (e, data) ->
    if data != undefined
      taxonomy_id = $("#menu-container").data("taxonomy_id")
      taxon_id = $(data.rslt.obj).data("id")
      $.ajax
        type: "DELETE"
        dataType: "json"
        url: "/shops/#{App.current_shop}/taxonomies/#{taxonomy_id}/taxons/#{taxon_id}"
        success: ->
          updatePreview()
        error: ->
          data.inst.refresh()
  )
  .on("move_node.jstree", (e, data) ->
    new_parent_id = (Number) $(data.rslt.np).data("id")
    new_position = (Number) data.rslt.cp
    #Menu items can't be moved before Home item
    if isNaN new_parent_id
      $.jstree.rollback(data.rlbk)
    else
      if (new_position is 0) and (new_parent_id is $("#menu-root").data("id"))
        $.jstree.rollback(data.rlbk)
      else
        new_position-- if new_parent_id is $("#menu-root").data("id")
        taxonomy_id = $("#menu-container").data("taxonomy_id")
        taxon_id = $(data.rslt.o).data("id")
        $.ajax
          type: "PUT"
          dataType: "json"
          url: "/shops/#{App.current_shop}/taxonomies/#{taxonomy_id}/taxons/#{taxon_id}"
          data:
            taxon:
              parent_id: new_parent_id
              position: new_position
          success: ->
            updatePreview()
          error: ->
            $.jstree.rollback(data.rlbk)
  )
  .on("select_node.jstree", (e, data) ->
    $("#add-item").removeAttr("disabled")
    if data.rslt.obj.attr("id") is "menu-root"
      $("#rename-item, #destroy-item").attr("disabled", "disabled")      
    else
      $("#rename-item, #destroy-item").removeAttr("disabled")
  )
  .on("deselect_node.jstree", () ->
    $("#rename-item, #add-item, #destroy-item").attr("disabled", "disabled")
  )

updatePreview = () ->
  taxonomy_id = $("#menu-container").data("taxonomy_id")
  $("#menu-preview-container").empty()
  $.get "/shops/#{App.current_shop}/taxonomies/#{taxonomy_id}.js", (data) ->
    eval(data)

