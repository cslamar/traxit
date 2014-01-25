module ApplicationHelper

  def menu_button_class(nav_item)
    if params[:controller] == nav_item
      return 'active'
    end
  end

  def regex_simple_name(simple_name)
    regex_simple_name = simple_name.gsub(/\'/, '')
    regex_simple_name = regex_simple_name.gsub(/\s/, '_')

    return regex_simple_name
  end

  def check_service_manual(wid,simple_name)

    if File.exist?("public/media/#{wid}/#{regex_simple_name(simple_name)}.pdf")
      return true
    else
      return false
    end
  end

end
