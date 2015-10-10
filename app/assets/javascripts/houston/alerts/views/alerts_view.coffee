class Houston.Alerts.AlertsView extends Backbone.View

  events:
    'change select.houston-alert-assign': 'assignAlert'
    'change select.houston-alert-project': 'setAlertProject'
    'click button.suppress-alert-button': 'suppressAlert'
    'click button.unsuppress-alert-button': 'unsuppressAlert'

  initialize: ->
    @renderAlert = HandlebarsTemplates['houston/alerts/show']
    @alerts = @options.alerts
    @workers = @options.workers
    @projects = @options.projects

    @$el.on 'click', '[rel="alert"]', (e)=>
      return if $(e.target).is('select, a, button, input')
      e.preventDefault()
      e.stopImmediatePropagation()
      url = $(e.target).closest('[rel="alert"]').attr('data-location')
      window.open url

  render: ->
    $unsuppressedAlerts = @$el.find('#unsuppressed_alerts tbody').empty()
    $suppressedAlerts = @$el.find('#suppressed_alerts tbody').empty()

    for alert in @alerts.toJSON()
      html = @renderAlert(_.extend(alert, workers: @workers, projects: @projects))
      if alert.suppressed
        $suppressedAlerts.append html
      else
        $unsuppressedAlerts.append html

    $('.table-sortable').tablesorter
      headers:
        1: {sorter: 'attr'}
        5: {sorter: 'attr'}

  assignAlert: (e)->
    $select = $(e.target)
    alertId = $select.closest('.houston-alert').attr('data-id')
    $.put "/alerts/#{alertId}", {checked_out_by_id: $select.val()}

  setAlertProject: (e)->
    $select = $(e.target)
    alertId = $select.closest('.houston-alert').attr('data-id')
    $.put "/alerts/#{alertId}", {project_id: $select.val()}

  suppressAlert: (e) ->
    e.preventDefault()
    $select = $(e.target)
    alertId = $select.closest('.houston-alert').attr('data-id')
    alert = @alerts.get(alertId)
    alert.save {suppressed: true},
      patch: true
      wait: true
      success: => @render()

  unsuppressAlert: (e) ->
    e.preventDefault()
    $select = $(e.target)
    alertId = $select.closest('.houston-alert').attr('data-id')
    alert = @alerts.get(alertId)
    alert.save {suppressed: false},
      patch: true
      wait: true
      success: => @render()
