class ItemsController < ApplicationController
  def list
  	@widget_list = Widget.all
  end

  def create

    if params[:purchase] == ""
      flash[:notice] = 'Failed to Create Widget!  Must have purchase info!'
      flash[:status] = 'danger'
      redirect_to :back
    end

    w = Widget.create(params[:widget])
    w.properties = params[:properties]

    w.purchase['purchase_date'] = w.purchase['purchase_date'].to_time

    if w.save
      flash[:notice] = 'Created Widget'
      flash[:status] = 'success'

      redirect_to(:controller => 'items', :action => 'list')
    else
      flash[:notice] = 'Failed to Create Widget'
      flash[:status] = 'danger'

      redirect_to :back
    end

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

    if !Dir.exists?("public/media/#{params[:wid]}")
      Dir.mkdir "public/media/#{params[:wid]}"
    end

    uploaded_io = params[:image]

    last_image = Dir["public/media/#{params[:wid]}/*.jpg"].to_a.last
    last_file_number = /(\d).jpg/.match(last_image).to_a[1]
    file_count = last_file_number.to_i + 1

    image_thumb = MiniMagick::Image.read(uploaded_io)

    #image_thumb.resize "200x200"
    #image_thumb.write  "thumb-test.jpg"

    image_thumb = resize_and_crop(image_thumb, 150)

    image_thumb.write "public/media/#{params[:wid]}/#{file_count}-thumb.jpg"

    File.open(Rails.root.join('public', 'media', "#{params[:wid]}", "#{file_count}.jpg"), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    flash[:notice] = 'Created New Image'
    flash[:status] = 'success'

    redirect_to :back
  end

  def big_image
    @image_info = Hash.new
    @image_info = {:wid => params[:id], :num => params[:num]}
  end

  def image
    @active_widget = params[:id]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def remove_image
    wid = params[:id]
    num = params[:num]

    File.delete(Rails.root + "public/media/#{wid}/#{num}.jpg")
    File.delete(Rails.root + "public/media/#{wid}/#{num}-thumb.jpg")

    flash[:notice] = 'Removed Image'
    flash[:status] = 'danger'

    redirect_to :back
  end

  def propitem
    @property = params[:property]

    render partial: 'items/propitem'
  end

  def overview
    #@active_widget = Widget.find(params[:id])
    @active_widget = params[:id]

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    w = Widget.find(params[:id])

    if w.destroy
      flash[:notice] = 'Successfully Removed Widget!!'
      flash[:status] = 'success'
    else
      flash[:notice] = 'Widget could not be removed'
      flash[:status] = 'warning'
    end

    redirect_to controller: 'items', action: 'list'
  end

  private

  def resize_and_crop(image, size)
    if image[:width] < image[:height]
      remove = ((image[:height] - image[:width])/2).round
      image.shave("0x#{remove}")
    elsif image[:width] > image[:height]
      remove = ((image[:width] - image[:height])/2).round
      image.shave("#{remove}x0")
    end
    image.resize("#{size}x#{size}")
    return image
  end
end
