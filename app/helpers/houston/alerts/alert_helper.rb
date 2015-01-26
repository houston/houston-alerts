module Houston::Alerts
  module AlertHelper
    
    def icon_for_alert(alert)
      "<i class=\"fa #{_icon_for_type(alert.type)}\"></i>".html_safe
    end
    
    def svg_for_alert(alert, size=32)
      "<img src=\"#{main_app.root_url}/images/#{_icon_for_type(alert.type)}.svg\" width=\"#{size * 2}\" height=\"#{size * 2}\" style=\"width: #{size}px; height: #{size}px;\" />".html_safe
    end
    
    def format_alert_deadline(alert)
      time = alert.deadline
      case time.to_date
        when Date.today then      time.strftime("%-I:%M %P")
        when Date.today + 1 then  time.strftime("%-I:%M %P<span class=\"weekday\">Tomorrow</span>")
        else                      time.strftime("%-I:%M %P<span class=\"weekday\">%A</span>")
      end.html_safe
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
