module Houston::Alerts
  module AlertHelper
    
    def icon_for_alert(alert)
      "<i class=\"fa #{_icon_for_type(alert.type)}\"></i>".html_safe
    end
    
    def _icon_for_type(type)
      case type
      when "itsm" then "fa-fire-extinguisher"
      when "cve" then "fa-bank"
      end
    end
    
  end
end
