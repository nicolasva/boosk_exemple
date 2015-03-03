class App.DashboardAnalytic extends Backbone.Model

  fake_data:
    like: [
      {
        count: 17
        product:
          name: "Boosket 1"
          uuid: "123456-890120"
          product_variants: [
            {
              is_master: true
              pictures: [
                {
                  is_master: true
                  picture:
                    url: App.default_product_picture_url
                }
              ]
            }
          ]
      }
      {
        count: 10
        product:
          name: "Boosket 3"
          uuid: "123456-890120"
          product_variants: [
            {
              is_master: true
              pictures: [
                {
                  is_master: true
                  picture:
                    url: App.default_product_picture_url
                }
              ]
            }
          ]
      }
      {
        count: 5
        product:
          name: "Boosket 2"
          uuid: "123456-890120"
          product_variants: [
            {
              is_master: true
              pictures: [
                {
                  is_master: true
                  picture:
                    url: App.default_product_picture_url
                }
              ]
            }
          ]
      }
    ]

  url: ->
    params = "?#{$.param({from: @format_date(@from), to: @format_date(@to)})}" if @from? and @to?
    params = "?#{$.param({period: @period})}" if @period
    return "/dashboard/general_analytics#{params ? ''}"

  format_date: (date) ->
    switch window.navigator.language
      when 'fr'
        return "#{date.split('/')[0]}/#{date.split('/')[1]}/#{date.split('/')[2]}"
      when 'en'
        return "#{date.split('/')[1]}/#{date.split('/')[0]}/#{date.split('/')[2]}"  

