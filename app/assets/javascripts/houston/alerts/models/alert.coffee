class Houston.Alerts.Alert extends Backbone.Model
  urlRoot: '/alerts'
  
  
  
class Houston.Alerts.Alerts extends Backbone.Collection
  model: Houston.Alerts.Alert
