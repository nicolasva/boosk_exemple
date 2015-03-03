class App.Views.Promotions.Edit extends Backbone.View
  el: '#modal'

  events:
    "submit form": "save"
    "click .back": "back"

  steps: ["global_info", "item_selection"]

  initialize: ->
    @translate = @options.translate
    @.$el.addClass('modal-promotions')
    self = @
    @.$el.one 'hidden', (e) ->
      $(@).removeClass('modal-promotions')
      self.undelegateEvents()
    @.$el.modal('show')
    @current_step = @steps[0]
    @model.on "error", @displayErrors, @

  displayErrors: (model, errors) ->
    $("#modal").scrollTop(0)
    new App.Views.Notice(message: errors, type: 'error', el: '#notice-modal')

  render: ->
    @innerView.remove() if @innerView
    switch @current_step
      when "global_info"
        @innerView = new App.Views.Promotions.GlobalForm(translate: @translate, model: @model)
        @.$('.modal-body').html(@innerView.render().el)
        @.$('.modal-header h3').html("#{@translate.views.promotion.edit_promotion} - #{@translate.views.promotion[@model.type()]}")
      when "item_selection"
        @items = new App.Collections.Products()
        @innerView = new App.Views.Promotions.ItemSelector(translate: @translate, model: @model, collection: @items)
        @.$('.modal-body').html(@innerView.render().el)
        @.$('.modal-header h3').html("#{@translate.views.promotion.edit_promotion} - #{@translate.views.promotion[@model.type()]}")
    @.$(".back").remove() if @is_first_step()
    App.eventsDispatcher.trigger "addedToDOM"
    return @

  save: (e) ->
    e.stopPropagation()
    e.preventDefault()
    form_data = $(e.target).toJSON()
    @model.set(form_data)
    if @model.valid
      if @is_last_step()
        @updateModel()
      else
        @next_step()
        @render()

  back: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @previous_step()
    @render()

  next_step: ->
    @current_step = @steps[@steps.indexOf(@current_step)+1]

  previous_step: ->
    @current_step = @steps[@steps.indexOf(@current_step)-1]

  updateModel: ->
    App.eventsDispatcher.trigger 'startLoading'
    self = @
    @model.set('ends_at', null) if @model.get('no_end_date')
    @model.save null,
      success: ->
        self.$el.modal('hide')
        App.eventsDispatcher.trigger 'loadingComplete'
      error: ->
        App.eventsDispatcher.trigger 'loadingComplete'

  is_first_step: ->
    @current_step is @steps[0]

  is_last_step: ->
    @current_step is @steps[@steps.length - 1]
