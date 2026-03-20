extends CanvasLayer

signal back_pressed

@onready var optionsContainer: MarginContainer = %OptionsContainer
@onready var backButton: Button = %BackButton
@onready var masterSlider: HSlider = %MasterSlider
@onready var sfxSlider: HSlider = %SfxSlider
@onready var musicSlider: HSlider = %MusicSlider


func _ready() -> void:
	backButton.pressed.connect(on_back_button_pressed)
	masterSlider.value_changed.connect(on_audio_slider_changed.bind("Master"))
	sfxSlider.value_changed.connect(on_audio_slider_changed.bind("Sfx"))
	musicSlider.value_changed.connect(on_audio_slider_changed.bind("Music"))
	masterSlider.grab_focus()
	update_display()


func update_display() -> void:
	masterSlider.value = get_bus_volume_percent("Master")
	sfxSlider.value = get_bus_volume_percent("Sfx")
	musicSlider.value = get_bus_volume_percent("Music")


func get_bus_volume_percent(busName: String) -> float:
	var busIndex = AudioServer.get_bus_index(busName)
	var volumeDB = AudioServer.get_bus_volume_db(busIndex)
	return db_to_linear(volumeDB)


func set_bus_volume_percent(busName: String, percent: float) -> void:
	var busIndex = AudioServer.get_bus_index(busName)
	var volumeDB = linear_to_db(percent)
	AudioServer.set_bus_volume_db(busIndex, volumeDB)


func on_back_button_pressed() -> void:
	back_pressed.emit()


func on_audio_slider_changed(value: float, busName: String) -> void:
	set_bus_volume_percent(busName, value)
