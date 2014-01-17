module ItemsHelper
	def complete_label(completed)
		if completed
			return '<span class="label label-success">Completed</span>'
		else
			return '<span class="label label-warning">In Progress</span>'
		end
  end

  def image_num(image)
    return /(\d)-thumb.jpg/.match(image).to_a[1].to_i
  end

end
