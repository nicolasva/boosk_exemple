class App.CommonViews.Twitter.TweetIt extends Backbone.View
  template: JST['facebook/common_templates/twitter/tweet_it']

  initialize: (options) ->
    @product = options.product.toJSON()
    @render()

  render: ->
    @window = window.open(Haml.render(@template(), {locals: {product: @product}}))
