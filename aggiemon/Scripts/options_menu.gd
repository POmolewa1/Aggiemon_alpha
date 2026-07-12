extends Control 

@export var overworld_menu: PanelContainer
@export var music_bus_name: String = "Music"
@export var sfx_bus_name: String = "SFX"
@export var music_slider: HSlider 
@export var sfx_slider: HSlider 


func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
	music_slider.value = 50.0
	sfx_slider.value = 50.0
	_on_music_slider_value_changed(music_slider.value)
	_on_sfx_slider_value_changed(sfx_slider.value)
	
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	
	

func open() -> void:
	visible = true
	_load_from_buses()
	

func close() -> void:
	visible = false
	if overworld_menu:
		overworld_menu.visible = true
		overworld_menu.is_open = true
		if overworld_menu.default_button:
			overworld_menu.default_button.grab_focus()

func _load_from_buses() -> void:
	var music_idx := AudioServer.get_bus_index(music_bus_name)
	var sfx_idx := AudioServer.get_bus_index(sfx_bus_name)
	
	var music_db := AudioServer.get_bus_volume_db(music_idx)
	var sfx_db := AudioServer.get_bus_volume_db(sfx_idx)
	
	music_slider.value = db_to_linear(music_db) * 100.0
	sfx_slider.value = db_to_linear(sfx_db) * 100.0

func _on_music_slider_value_changed(value: float) -> void:
	var idx := AudioServer.get_bus_index(music_bus_name)
	var linear := value / 100.0
	
	if linear <= 0.001:
		AudioServer.set_bus_mute(idx, true)
	else:
		AudioServer.set_bus_mute(idx, false)
		AudioServer.set_bus_volume_db(idx, linear_to_db(linear))
		
func _on_sfx_slider_value_changed(value: float) -> void:
	var idx := AudioServer.get_bus_index(sfx_bus_name)
	var linear := value / 100.0
	
	if linear <= 0.001:
		AudioServer.set_bus_mute(idx, true)
	else:
		AudioServer.set_bus_mute(idx, false)
		AudioServer.set_bus_volume_db(idx, linear_to_db(linear))

func _on_back_button_pressed() -> void:
	close()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("menu"):
		close()
		get_viewport().set_input_as_handled()
