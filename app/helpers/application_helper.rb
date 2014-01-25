module ApplicationHelper

  def menu_button_class(nav_item)
    if params[:controller] == nav_item
      return 'active'
    end
  end

  def check_service_manual

  end
end
