module Houston::Alerts
  module AlertHelper
    
    def icon_for_alert(alert)
      "<i class=\"fa #{_icon_for_type(alert.type)}\"></i>".html_safe
    end
    
    def svg_for_alert(alert, size=32)
      "<img src=\"#{main_app.root_url}/images/#{_icon_for_type(alert.type)}.svg\" width=\"#{size * 2}\" height=\"#{size * 2}\" style=\"width: #{size}px; height: #{size}px;\" />".html_safe
    end
    
    def format_alert_deadline(alert)
      deadline = alert.deadline
      due_date = deadline.to_date
      today = Date.today

      if due_date < today
        "Past"
      elsif due_date == today
        deadline.strftime("%-I:%M %P")
      elsif due_date == today + 1
        deadline.strftime("%-I:%M %P<span class=\"weekday\">Tomorrow</span>").html_safe
      else
        deadline.strftime("%-I:%M %P<span class=\"weekday\">%A</span>").html_safe
      end
    end
    
    def _icon_for_type(type)
      case type
      when "itsm" then "fa-fire-extinguisher"
      when "err" then "fa-bug"
      when "cve" then "fa-bank"
      end
    end
    
  end
end
