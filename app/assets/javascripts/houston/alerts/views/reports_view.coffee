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
      alert.weekOpened = @getBeginningOfWeek(alert.opened)
    @alerts = _.sortBy(@alerts, 'closed')

  render: ->
    @$el.html """
      <h3>Hours Spent on Alerts by Type</h3>
      <div id="alert_time_by_type" class="graph"></div>
      
      <h3>Alerts by Project</h3>
      <table class="alerts-by-project">
        <thead>
          <tr>
            <th class="invisible"></th>
            <th colspan="3">Number Opened</th>
            <th colspan="3">Hours Spent</th>
          </tr>
          <tr>
            <th></th>
            <th>CVEs</th>
            <th>ITSMs</th>
            <th>Exceptions</th>
            <th>CVEs</th>
            <th>ITSMs</th>
            <th>Exceptions</th>
          </tr>
        </thead>
        <tbody id="alerts_by_project_and_type"></tbody>
      </table>
    """
    
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
    
    weeks = alertsByWeek.map ([date, args...])-> date
    maxCount = 0
    maxEffort = 0
    alertsByTypeByProject = d3.nest()
      .key((alert)-> alert.projectSlug)
      .entries(@alerts)
      .map (entry)->
        values = for type in types
          openedByWeek = for week in weeks
            alerts = _.select entry.values, (alert)->
              _.isEqual(alert.weekOpened, week) and alert.type is type
            sum = alerts.length
            maxCount = d3.max [sum, maxCount]
            [week, sum]
          closedByWeek = for week in weeks
            alerts = _.select entry.values, (alert)->
              _.isEqual(alert.week, week) and alert.type is type
            sum = d3.sum alerts, (alert)-> alert.hours
            maxEffort = d3.max [sum, maxEffort]
            [week, sum]
          key: type
          opened: openedByWeek
          closed: closedByWeek
        key: entry.key
        values: values
    
    rows = d3.select('#alerts_by_project_and_type')
      .selectAll('tr')
      .data(alertsByTypeByProject)
        .enter()
          .append('tr')
    
    rows.append('th')
      .text((d)-> d.key)
    
    rows.selectAll('.opened')
      .data((d)-> d.values)
        .enter()
          .append('td')
          .attr('class', 'opened')
          .each (d)->
            graph = new Houston.StackedBarGraph()
              .selector(@)
              .legend(false)
              .labels(['Count'])
              .colors(['rgb(243, 101, 66)'])
              .range([0, maxCount])
              .width(108)
              .height(40)
              .margin(top: 0, left: 24, right: 0, bottom: 0)
              .data(d.opened)
              .yTicks([5, 10])
              .render()
  
    rows.selectAll('.closed')
      .data((d)-> d.values)
        .enter()
          .append('td')
          .attr('class', 'closed')
          .each (d)->
            graph = new Houston.StackedBarGraph()
              .selector(@)
              .legend(false)
              .labels(['Count'])
              .colors(['rgb(31, 138, 180)'])
              .range([0, maxEffort])
              .width(108)
              .height(40)
              .margin(top: 0, left: 24, right: 0, bottom: 0)
              .data(d.closed)
              .yTicks([2, 4, 6])
              .render()
  
  getBeginningOfWeek: (time)->
    wday = time.getDay() # 0-6 (0=Sunday)
    daysSinceMonday = wday - 1
    daysSinceMonday += 7 if daysSinceMonday < 0
    daysSinceMonday.days().before(time)
