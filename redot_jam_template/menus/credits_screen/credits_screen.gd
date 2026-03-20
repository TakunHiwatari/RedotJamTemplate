extends CanvasLayer

signal back_pressed

@onready var backButton: Button = %BackButton


func _ready() -> void:
	backButton.pressed.connect(on_back_button_pressed)
	backButton.grab_focus()


func on_back_button_pressed() -> void:
	back_pressed.emit()
