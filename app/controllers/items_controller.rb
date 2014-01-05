class ItemsController < ApplicationController
  def list
  	@widget_list = Widget.all
  end

  def info
  	@active_widget = Widget.find(params[:id])
  	@service_list = @active_widget.services.sort_by{|e| e[:start]}.reverse
  end

  def notes
  	@pid = params[:pid]
  	@si = ActiveSupport::JSON.decode(params[:si])

  	respond_to do |format|
  		format.html
  		format.js
  	end
  end
end
