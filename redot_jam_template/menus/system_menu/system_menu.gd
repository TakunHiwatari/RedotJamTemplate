extends MarginContainer

@export var titleScreen: PackedScene

@onready var audioButton: Button = %AudioButton
@onready var controlsButton: Button = %ControlsButton
@onready var displayButton: Button = %DisplayButton
@onready var windowButton: Button = %WindowButton
@onready var returnButton: Button = %ReturnButton

var audioScreenScene = preload(Constants.MENUS.Audio)
var controlsScreenScene = preload(Constants.MENUS.Controls)
var displayScreenScene = preload(Constants.MENUS.Display)
var isClosing: bool


func _ready() -> void:
	get_tree().paused = true
	
	audioButton.pressed.connect(on_submenu_opened.bind(audioScreenScene, audioButton))
	controlsButton.pressed.connect(on_submenu_opened.bind(controlsScreenScene, controlsButton))
	displayButton.pressed.connect(on_submenu_opened.bind(displayScreenScene, displayButton))
	windowButton.pressed.connect(on_window_button_pressed)
	returnButton.pressed.connect(on_return_pressed)
	audioButton.grab_focus()
	update_display()


func _unhandled_input(event) -> void:
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()


func close() -> void:
	if isClosing:
		return
	
	get_tree().paused = false
	queue_free()


func on_window_button_pressed() -> void:
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	update_display()


func update_display() -> void:
	windowButton.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		windowButton.text = "Fullscreen"


func on_return_pressed() -> void:
	if titleScreen == null:
		push_error("There is no Title Screen!")
		return
	
	get_tree().paused = false
	var titleScreenName = titleScreen.resource_path
	get_tree().change_scene_to_file(titleScreenName)


func on_submenu_opened(submenuScreen: PackedScene, submenuButton: Button) -> void:
	var submenuInstance = submenuScreen.instantiate()
	add_child(submenuInstance)
	submenuInstance.back_pressed.connect(on_submenu_back_pressed.bind(submenuInstance, submenuButton))


func on_submenu_back_pressed(submenu: Node, submenuButton: Button) -> void:
	submenu.queue_free()
	submenuButton.grab_focus()
