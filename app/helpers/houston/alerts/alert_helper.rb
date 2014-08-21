module Houston::Alerts
  module AlertHelper
    
    def icon_for_alert(alert)
      "<i class=\"fa #{_icon_for_type(alert.type)}\"></i>".html_safe
    end
    
    def svg_for_alert(alert, size=32)
      "<img src=\"#{main_app.root_url}/icons/#{_icon_for_type(alert.type)}.svg\" width=\"#{size * 2}\" height=\"#{size * 2}\" style=\"width: #{size}px; height: #{size}px;\" />".html_safe
    end
    
    def _icon_for_type(type)
      case type
      when "itsm" then "fa-fire-extinguisher"
      when "cve" then "fa-bank"
      end
    end
    
  end
end
