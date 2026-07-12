extends Control

@export var overworld_menu: PanelContainer
@export var map_texture: Texture2D 
@export var map_rect: TextureRect 

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS 
	
	if map_texture:
		map_rect.texture = map_texture 

func open() -> void:
	visible = true
	if map_texture:
		map_rect.texture = map_texture

func close() -> void:
	visible = false
	if overworld_menu:
		overworld_menu.visible = true
		overworld_menu.is_open = true
		if overworld_menu.default_button:
			overworld_menu.default_button.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("menu"):
		close()
		get_viewport().set_input_as_handled()
