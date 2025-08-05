extends MarginContainer

@export var inputs: Array[String]
@export var labelTheme: Theme
@export var buttonTheme: Theme

@onready var remapContainer: GridContainer = %RemapContainer

func _ready() -> void:
	_create_action_remap()


func _create_action_remap() -> void:
	var previousItem;
	
	for index in range(inputs.size()):
		var action = inputs[index]
		
		var label = Label.new()
		label.text = action
		label.theme = labelTheme
		remapContainer.add_child(label)
		
		var button = RemapButton.new()
		button.action = action
		button.theme = buttonTheme
		remapContainer.add_child(button)
		
		if index != 0:
			button.focus_neighbor_top = previousItem.get_path()
			previousItem.focus_neighbor_bottom = button.get_path()
		
			button.grab_focus()
		
		previousItem = button
