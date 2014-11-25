module Houston::Alerts
  module AlertHelper
    
    def icon_for_alert(alert)
      "<i class=\"fa #{_icon_for_type(alert.type)}\"></i>".html_safe
    end
    
    def svg_for_alert(alert, size=32)
      "<img src=\"#{main_app.root_url}/images/#{_icon_for_type(alert.type)}.svg\" width=\"#{size * 2}\" height=\"#{size * 2}\" style=\"width: #{size}px; height: #{size}px;\" />".html_safe
    end
    
    def countdown_for_alert(alert)
      timeleft = alert.seconds_remaining
      seconds = timeleft.abs
      minutes = (seconds / 60).floor
      hours = (minutes / 60).floor
      days = (hours / 24).floor
      
      format = lambda { |n| "%02d" % n }
      
      label = format[seconds % 60]
      label = "#{format[minutes % 60]}:#{label}" if minutes >= 1
      label = "#{(hours % 24).floor}:#{label}" if hours >= 1
      label = "<span class=\"label\">#{days.floor}d</span> #{label}" if days >= 1
      label = "<span class=\"late\">+ #{label}</span>" if timeleft < 0
      
      label.html_safe
    end
    
    def _icon_for_type(type)
      case type
      when "itsm" then "fa-fire-extinguisher"
      when "ue" then "fa-bug"
      when "cve" then "fa-bank"
      end
    end
    
  end
end
