extends CanvasLayer

signal back_pressed

@export var inputs: Array[String]
@export var labelTheme: Theme
@export var buttonTheme: Theme

@onready var remapContainer: GridContainer = %RemapContainer
@onready var backButton: Button = %BackButton


func _ready() -> void:
	_create_action_remap()
	backButton.theme = buttonTheme
	backButton.pressed.connect(_on_back_button_pressed)
	backButton.grab_focus()


func _create_action_remap() -> void:
	var previousItem = backButton
	
	for input in range(inputs.size()):
		var action = inputs[input]
		
		var label = Label.new()
		label.text = action
		label.theme = labelTheme
		remapContainer.add_child(label)
		
		var button = RemapButton.new()
		button.action = action
		button.theme = buttonTheme
		remapContainer.add_child(button)
		
		if input != 0:
			button.focus_neighbor_top = previousItem.get_path()
			previousItem.focus_neighbor_bottom = button.get_path()
		
		if input == inputs.size() - 1:
			backButton.focus_neighbor_top = button.get_path()
			button.focus_neighbor_bottom = backButton.get_path()
		
		if input == 0:
			button.focus_neighbor_bottom = backButton.get_path()
			button.grab_focus()
		
		previousItem = button


func _on_back_button_pressed() -> void:
	back_pressed.emit()
