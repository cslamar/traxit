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

  def properties
  	wid = params[:id]

  	@active_widget = Widget.find(wid)

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
  		## Prod
  		# format.svg { render :qrcode => "#{request.protocol}#{request.host}:#{request.port}/items/info/#{params[:id]}", :level => :l, :unit => 10 }

  		## Dev
  		format.svg { render :qrcode => "#{request.protocol}#{request.host}:#{request.port}/items/info/#{params[:id]}", :level => :l, :unit => 10 }
  	end
  end

  def new_field
    render partial: 'items/new_field'
  end

  def update_properties
    active_widget = Widget.find(params[:id])

    puts "Current Properties: #{active_widget.properties}"

    props = ActiveSupport::JSON.decode(params[:props])
    puts "JSON: #{props}"

    active_widget.properties = props

    if active_widget.save
      respond_to do |format|
        format.json { render json: {'success' => true}, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: {'success' => false}, status: 500 }
      end
    end

  end

  def update_image

    uploaded_io = params[:image]

    File.open(Rails.root.join('public', 'media', "#{params[:wid]}.jpg"), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    flash[:notice] = 'Created New Image'
    flash[:status] = 'success'

    redirect_to :back
  end

end
