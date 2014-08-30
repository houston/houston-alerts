class Houston.Alerts.AlertsView extends Backbone.View

  initialize: ->
    @renderAlert = HandlebarsTemplates['houston/alerts/show']
    @alerts = @options.alerts
    
    @$el.on 'click', '[rel="alert"]', (e)=>
      e.preventDefault()
      e.stopImmediatePropagation()
      url = $(e.target).closest('[rel="alert"]').attr('data-location')
      window.open url

  render: ->
    @$el.empty()
    for alert in @alerts.toJSON()
      @$el.append @renderAlert(alert)
    $('.table-sortable').tablesorter()
