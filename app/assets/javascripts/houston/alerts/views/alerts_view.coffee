class Houston.Alerts.AlertsView extends Backbone.View

  events:
    'change select.houston-alert-assign': 'assignAlert'
    'change select.houston-alert-project': 'setAlertProject'
    'change :checkbox.houston-alert-verify': 'verifyAlert'

  initialize: ->
    @renderAlert = HandlebarsTemplates['houston/alerts/show']
    @alerts = @options.alerts
    @workers = @options.workers
    @projects = @options.projects
    
    @$el.on 'click', '[rel="alert"]', (e)=>
      return if $(e.target).is('select, a, button, input, label')
      e.preventDefault()
      e.stopImmediatePropagation()
      url = $(e.target).closest('[rel="alert"]').attr('data-location')
      window.open url

  render: ->
    @$el.empty()
    for alert in @alerts.toJSON()
      @$el.append @renderAlert(_.extend(alert, workers: @workers, projects: @projects))

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

  verifyAlert: (e)->
    $checkbox = $(e.target)
    alertId = $checkbox.closest('.houston-alert').attr('data-id')
    $.put "/alerts/#{alertId}", {verified: $checkbox.prop('checked')}
