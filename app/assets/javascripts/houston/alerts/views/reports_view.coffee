class Houston.Alerts.ReportsView extends Backbone.View

  initialize: ->
    @alerts = @options.alerts
    
    for alert in @alerts
      alert.hours = +alert.hours
      alert.closed = new Date(alert.closed)
      alert.closedDate = App.truncatedDate(alert.closed)
      alert.opened = new Date(alert.opened)
      alert.deadline = new Date(alert.deadline)
      alert.onTime = alert.closed < alert.deadline
      alert.week = @getBeginningOfWeek(alert.closed)
    @alerts = _.sortBy(@alerts, 'closed')

  render: ->
    @$el.html '''
      <h3>Hours Spent on Alerts by Type</h3>
      <div id="alert_time_by_type" class="graph"></div>
    '''
    
    types = ['cve', 'itsm', 'exception']
    
    alertsByWeek = d3.nest()
      .key((alert)-> alert.week)
      .entries(@alerts)
      .map (entry)->
        week = new Date(entry.key)
        hoursByType = {'cve': 0, 'itsm': 0, 'exception': 0}
        for alert in entry.values
          hoursByType[alert.type] += alert.hours
        [week, hoursByType.cve, hoursByType.itsm, hoursByType.exception]
    
    new Houston.StackedAreaGraph()
      .selector(@$el.find('#alert_time_by_type')[0])
      .labels(types)
      .data(alertsByWeek)
      .render()
  
  getBeginningOfWeek: (time)->
    wday = time.getDay() # 0-6 (0=Sunday)
    daysSinceMonday = wday - 1
    daysSinceMonday += 7 if daysSinceMonday < 0
    daysSinceMonday.days().before(time)
