extends Control

@export var character: Node
@export var character_sprite: Sprite2D


@export var stats_label: Label
@export var portrait: TextureRect 
@export var overworld_menu: PanelContainer
func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func open() -> void:
	visible = true
	update_stats()

func close() -> void:
	visible = false
	if overworld_menu:
		overworld_menu.visible = true
		overworld_menu.is_open = true
		if overworld_menu.default_button:
			overworld_menu.default_button.grab_focus()

func update_stats() -> void:
	if character and character.has_method("get_stat_info"):
		stats_label.text = character.get_stat_info()
	
	if character_sprite:
		portrait.texture = character_sprite.texture

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("menu"):
		close()
		get_viewport().set_input_as_handled()
