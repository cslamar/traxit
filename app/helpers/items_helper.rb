module ItemsHelper
	def complete_label(completed)
		if completed
			return '<span class="label label-success">Completed</span>'
		else
			return '<span class="label label-warning">In Progress</span>'
		end
	end
end
