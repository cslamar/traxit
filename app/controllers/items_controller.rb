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

  def service_add
  	@wid = params[:id]

  	# @simple_name = params[:simple_name]
  	# @active_widget = Widget.find(@wid)

  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def service_create
  	# puts "Create #{params[:id]}"

  	w = Widget.find(params[:id])
  	s = Service.new(start: params[:start], short_description: params[:short_description], long_description: params[:long_description])

  	if w.services << s
  		flash[:notice] = 'Created Service Task'
  		flash[:status] = 'success'

  		redirect_to :back
  	else
  		flash[:notice] = 'Failed to add Service Task'
  		flash[:status] = 'danger'

  		redirect_to :back
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

  def reset
  	wid = params[:wid]
  	sid = params[:sid]

  	active_widget = Widget.find(wid)
  	active_service = active_widget.services.detect {|s| s["_id"].to_s == sid }

  	active_service.completed = false
  	active_service.unset(:finish)

  	if active_service.save
	  	respond_to do |format|
	  		format.json { render json: {'something' => 'asdf'}, status: :ok }
	  	end
	  end
  end

  def qr
  	respond_to do |format|
  		format.html
  		format.svg { render :qrcode => "http://172.16.13.88:3000/items/info/#{params[:id]}", :level => :l, :unit => 10 }
  	end
  end

end
