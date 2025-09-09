extends OptionButton

var resolutions = {
	"1280x720": Vector2i(1280, 720),
	"1920x1080": Vector2i(1920, 1080),
	"2560x1440": Vector2i(2560, 1440),
	"3840x2160": Vector2i(3840, 2160)
}

func _ready():
	# Populate the OptionButton with resolutions
	for res_name in resolutions.keys():
		add_item(res_name)
		set_item_metadata(item_count - 1, resolutions[res_name]) # Store the Vector2i as metadata

	# Set the current resolution as the default selection
	var current_res = get_window().size
	for i in range(item_count):
		if get_item_metadata(i) == current_res:
			selected = i
			break
