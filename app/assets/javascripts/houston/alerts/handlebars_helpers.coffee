ICONS =
  itsm: 'fa-fire-extinguisher'
  cve: 'fa-bank'
  exception: 'fa-bug'

Handlebars.registerHelper 'iconForAlert', (alertType)->
  icon = ICONS[alertType]
  size = 24
  "<img src=\"/images/#{icon}.svg\" width=\"#{size * 2}\" height=\"#{size * 2}\" style=\"width: #{size}px; height: #{size}px;\" />"
