class Houston.Alerts.AlertsView extends Backbone.View

  events:
    'change select.houston-alert-assign': 'assignAlert'

  initialize: ->
    @renderAlert = HandlebarsTemplates['houston/alerts/show']
    @alerts = @options.alerts
    @workers = @options.workers
    
    @$el.on 'click', '[rel="alert"]', (e)=>
      return if $(e.target).is('select, a, button, input')
      e.preventDefault()
      e.stopImmediatePropagation()
      url = $(e.target).closest('[rel="alert"]').attr('data-location')
      window.open url

  render: ->
    @$el.empty()
    for alert in @alerts.toJSON()
      @$el.append @renderAlert(_.extend(alert, workers: @workers))

    $('.table-sortable').tablesorter
      headers:
        1: {sorter: 'attr'}
        5: {sorter: 'attr'}

  assignAlert: (e)->
    $select = $(e.target)
    alertId = $select.closest('.houston-alert').attr('data-id')
    $.put "/alerts/#{alertId}", {checked_out_by_id: $select.val()}
