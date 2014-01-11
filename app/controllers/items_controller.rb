class ItemsController < ApplicationController
  def list
  	@widget_list = Widget.all
  end

  def info
  	@active_widget = Widget.find(params[:id])
  	@service_list = @active_widget.services.sort_by{|e| e[:start]}.reverse
  end

  def notes
  	@wid = params[:wid]
  	sid = params[:sid]

  	@active_widget = Widget.find(@wid)
  	@service = @active_widget.services.find(sid)

  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def complete
  	wid = params[:wid]
  	sid = params[:sid]

  	active_widget = Widget.find(wid)
  	active_service = active_widget.services.detect {|s| s["_id"].to_s == sid }

  	# puts "Short Desc: #{active_service.short_description}"

  	active_service.completed = true
  	active_service.finish = params[:complete_date]

  	if active_service.save
	  	respond_to do |format|
	  		format.json { render json: {'something' => 'asdf'}, status: :ok }
	  	end
	  end

  end

end
