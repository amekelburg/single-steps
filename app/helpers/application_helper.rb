module ApplicationHelper
  
  def icon_path(icon_group, icon, size='24')
    "/icons8/Color/PNG/#{size}/#{icon_group}/#{icon}-#{size}.png"
  end
  
end
