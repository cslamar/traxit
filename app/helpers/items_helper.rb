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

  def properties_map_reducer
    map = %q{
      function() {
        for (var key in this.properties) {
          emit(key, null);
        }
      }
    }

    reduce = %q{
      function(key, stuff) {
        return null;
      }
    }

    results = Widget.map_reduce(map, reduce).out(inline: true)

    property_list = Array.new

    results.each do |r|
      property_list.push(r["_id"])
    end

    return property_list
  end

end
