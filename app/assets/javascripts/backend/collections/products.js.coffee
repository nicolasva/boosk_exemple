class App.Collections.Products extends Backbone.Collection
  model: App.Product

  bulk_destroy_url: ->
    "/shops/#{App.current_shop}/products/destroy/all"

  bulk_copy_url: ->
    "/shops/#{App.current_shop}/products/copy"

  url: ->
    @searchParams.page = @page
    @searchParams.perPage = @perPage
    "/shops/#{App.current_shop}/products?#{$.param(@searchParams)}"


  initialize: ->
    @page = 1
    typeof(@perPage) != 'undefined' or @perPage = 10
    @searchParams = {}

  parse: (response) ->
    @page = response.page
    @perPage = response.perPage
    @total = response.total
    return response.products

  pageInfo: ->
    info =
      total: @total
      page: @page
      perPage: @perPage
      pages: Math.ceil(@total / @perPage)
      prev: false
      next: false

    max = Math.min(@total, @page * @perPage)

    if @total == (@pages * @perPage)
       max = @total

    info.range = [(@page - 1) * @perPage + 1, max]

    if @page > 1
      info.prev = @page - 1

    if @page < info.pages
      info.next = @page + 1


    if info.pages >= 4
      if info.page >= 3
        if info.pages - info.page <= 1
          info.range =
            first: 1
            rest: (num for num in [(info.page - 1)..info.pages])
        else
          info.range =
            first: 1
            rest: (num for num in [(info.page - 1)..(info.page + 1)])
            last: info.pages
      else
        info.range =
          rest: (num for num in [1..3])
          last: info.pages
    else
      info.range =
        rest: (num for num in [1..info.pages])

    return info


  nextPage: ->
    unless @.pageInfo().next
      return false
    @page += 1
    App.eventsDispatcher.trigger 'startLoading'
    @fetch
      success: ->
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  previousPage: ->
    unless @.pageInfo().prev
      return false
    @page -= 1
    App.eventsDispatcher.trigger 'startLoading'
    @fetch
      success: ->
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  atPage: (page) ->
    if page <= @total and page >= 1
      @page = page
      App.eventsDispatcher.trigger 'startLoading'
      @fetch
        success: ->
          App.eventsDispatcher.trigger 'loadingComplete'
        error: ->
          App.eventsDispatcher.trigger 'loadingComplete'

  viewPerPage: (number) ->
    @perPage = number
    App.eventsDispatcher.trigger 'startLoading'
    @fetch
      success: ->
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  isFirstPage: ->
    return @page is 1

  isLastPage: ->
    return @page is @pageInfo().pages