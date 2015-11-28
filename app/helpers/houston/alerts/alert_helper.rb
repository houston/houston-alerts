module Houston::Alerts
  module AlertHelper

    def icon_for_alert(alert)
      "<i class=\"fa #{_icon_for_type(alert.type)}\"></i>".html_safe
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
      Houston::Alerts.config.icons_by_type.fetch type
    end

  end
end
