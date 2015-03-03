App.CreateDynamicPage = (nb_pages) ->
  array_page_div = new Array()
  for num_page in [1..nb_pages]
    array_page_div.push(num_page)
  array_page_div
