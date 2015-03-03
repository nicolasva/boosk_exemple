$("#menu-preview-container").html("<%= escape_javascript( render(partial: 'menu_preview', locals: {taxonomy: @taxonomy}) ) %>");
