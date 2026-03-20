extends CanvasLayer

signal back_pressed

# Resolution data: { aspect_label: { width: int, height: int } }
const RESOLUTIONS: Dictionary = {
	"16:9": [
		{ "label": "1280 × 720",  "width": 1280, "height": 720  },
		{ "label": "1600 × 900",  "width": 1600, "height": 900  },
		{ "label": "1920 × 1080", "width": 1920, "height": 1080 },
		{ "label": "2560 × 1440", "width": 2560, "height": 1440 },
	],
	"16:10": [
		{ "label": "1280 × 800",  "width": 1280, "height": 800  },
		{ "label": "1440 × 900",  "width": 1440, "height": 900  },
		{ "label": "1680 × 1050", "width": 1680, "height": 1050 },
		{ "label": "1920 × 1200", "width": 1920, "height": 1200 },
	],
	"4:3": [
		{ "label": "800 × 600",   "width": 800,  "height": 600  },
		{ "label": "1024 × 768",  "width": 1024, "height": 768  },
		{ "label": "1280 × 960",  "width": 1280, "height": 960  },
		{ "label": "1600 × 1200", "width": 1600, "height": 1200 },
	],
	"3:2": [
		{ "label": "1152 × 768",  "width": 1152, "height": 768  },
		{ "label": "1440 × 960",  "width": 1440, "height": 960  },
		{ "label": "1920 × 1280", "width": 1920, "height": 1280 },
		{ "label": "2160 × 1440", "width": 2160, "height": 1440 },
	],
}

const ASPECT_ORDER: Array = ["16:9", "16:10", "4:3", "3:2"]

@onready var displayContainer: MarginContainer = %DisplayContainer
@onready var aspectOptionButton: OptionButton = %AspectOptionButton
@onready var resolutionOptionButton: OptionButton = %ResolutionOptionButton
@onready var applyButton: Button = %ApplyButton
@onready var backButton: Button = %BackButton


func _ready() -> void:
	_populate_aspect_options()
	aspectOptionButton.item_selected.connect(_on_aspect_selected)
	applyButton.pressed.connect(_on_apply_pressed)
	backButton.pressed.connect(_on_back_pressed)
	aspectOptionButton.grab_focus()
	_load_current_resolution()


func _populate_aspect_options() -> void:
	aspectOptionButton.clear()
	for aspect in ASPECT_ORDER:
		aspectOptionButton.add_item(aspect)


func _populate_resolution_options(aspect: String) -> void:
	resolutionOptionButton.clear()
	for res in RESOLUTIONS[aspect]:
		resolutionOptionButton.add_item(res["label"])


func _on_aspect_selected(index: int) -> void:
	var aspect: String = ASPECT_ORDER[index]
	_populate_resolution_options(aspect)
	_select_closest_resolution(aspect)


func _select_closest_resolution(aspect: String) -> void:
	var current_size: Vector2i = DisplayServer.window_get_size()
	var resolutions: Array = RESOLUTIONS[aspect]
	var best_index: int = 0
	var best_diff: int = INF

	for i in resolutions.size():
		var res = resolutions[i]
		var diff = abs(res["width"] - current_size.x) + abs(res["height"] - current_size.y)
		if diff < best_diff:
			best_diff = diff
			best_index = i

	resolutionOptionButton.select(best_index)


func _load_current_resolution() -> void:
	var current_size: Vector2i = DisplayServer.window_get_size()

	# Try to find the current window size among known resolutions and select
	# the matching aspect ratio first.
	for i in ASPECT_ORDER.size():
		var aspect: String = ASPECT_ORDER[i]
		for j in RESOLUTIONS[aspect].size():
			var res = RESOLUTIONS[aspect][j]
			if res["width"] == current_size.x and res["height"] == current_size.y:
				aspectOptionButton.select(i)
				_populate_resolution_options(aspect)
				resolutionOptionButton.select(j)
				return

	# No exact match — pick the aspect ratio whose ratio is closest to the
	# current window and highlight the nearest available resolution.
	var current_ratio: float = float(current_size.x) / float(current_size.y)
	var best_aspect_index: int = 0
	var best_ratio_diff: float = INF

	for i in ASPECT_ORDER.size():
		var parts: PackedStringArray = ASPECT_ORDER[i].split(":")
		var ratio: float = float(parts[0]) / float(parts[1])
		var diff: float = abs(ratio - current_ratio)
		if diff < best_ratio_diff:
			best_ratio_diff = diff
			best_aspect_index = i

	aspectOptionButton.select(best_aspect_index)
	var aspect: String = ASPECT_ORDER[best_aspect_index]
	_populate_resolution_options(aspect)
	_select_closest_resolution(aspect)


func _on_apply_pressed() -> void:
	var aspect_index: int = aspectOptionButton.selected
	var res_index: int = resolutionOptionButton.selected

	if aspect_index < 0 or res_index < 0:
		return

	var aspect: String = ASPECT_ORDER[aspect_index]
	var res: Dictionary = RESOLUTIONS[aspect][res_index]
	var new_size := Vector2i(res["width"], res["height"])

	# Only switch away from fullscreen if currently fullscreen, so the chosen
	# windowed resolution actually becomes visible.
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	DisplayServer.window_set_size(new_size)

	# Centre the window on the primary screen after resizing.
	var screen_size: Vector2i = DisplayServer.screen_get_size()
	var window_pos := Vector2i(
		(screen_size.x - new_size.x) / 2,
		(screen_size.y - new_size.y) / 2
	)
	DisplayServer.window_set_position(window_pos)


func _on_back_pressed() -> void:
	back_pressed.emit()
