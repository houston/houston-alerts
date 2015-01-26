ICONS =
  itsm: 'fa-fire-extinguisher'
  cve: 'fa-bank'
  ue: 'fa-bug'

Handlebars.registerHelper 'iconForAlert', (alertType)->
  icon = ICONS[alertType]
  size = 24
  "<img src=\"/images/#{icon}.svg\" width=\"#{size * 2}\" height=\"#{size * 2}\" style=\"width: #{size}px; height: #{size}px;\" />"

Handlebars.registerHelper 'ifEql', (value1, value2, options)->
  if value1 == value2
    options.fn(@)

Handlebars.registerHelper 'formatAlertDeadline', (deadline)->
  deadline = new Date(Date.parse(deadline)) if _.isString(deadline)
  d3.time.format('%-I:%M %p<span class="weekday">%A</span>')(deadline).replace /AM|PM/, (s)-> s.toLowerCase()
