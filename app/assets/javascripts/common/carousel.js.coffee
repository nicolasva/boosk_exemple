window.Carousel = class Carousel

  right_click: 0
  left_click: 0
  anim_finish: true

  constructor: (options) ->
    @options = options
    @container = options.container
    @items = $(options.container).find('div')
    @right_click = @items.length - options.nb_visible
    @item_size = @calcul_size_item()
    $("#carousel div[class|='arrow']").live 'click', @, @move_to


  add_item: ->
    @right_click += 1

  remove_item: ->
    @right_click -= 1
    $(@container).css('margin-left', 0)


  move_to: (e) =>
    switch $(e.target).attr('class').split('-')[1]
      when 'right'
        if @right_click > 0 and @anim_finish
          @anim_finish = false
          calc = parseInt($(@container).css('margin-left')) - @item_size
          $(@container).animate({'margin-left': "#{calc}px"}, 500, =>
            @anim_finish = true
          )
          @right_click -= 1
          @left_click += 1
      when 'left'
        if @left_click > 0  and @anim_finish
          @anim_finish = false
          calc = parseInt($(@container).css('margin-left')) + @item_size
          $(@container).animate({'margin-left': "#{calc}px"}, 500, =>
            @anim_finish = true
          )
          @left_click -= 1
          @right_click += 1


  calcul_size_item: =>
    width = parseInt($(@items[1]).width())
    margin_left = parseInt($(@items[1]).css('margin-left')) ? 0
    margin_right= parseInt($(@items[1]).css('margin-right')) ? 0
    border = parseInt($(@items[1]).css('border-right-width')[0] * 2) if @items[1]?
    return (width + margin_left + margin_right + border)
