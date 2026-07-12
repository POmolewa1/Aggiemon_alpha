extends PanelContainer

var is_open: bool = false
@export var default_button: Button
@export var stats_menu: Control
@export var skills_menu: Control
@export var map_menu: Control 
@export var options_menu: Control

@onready var open_sfx := $OpenSFX
@onready var cursor_sfx := $CursorSFX


func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if is_open:
			close_menu()
		else:
			open_menu()

func open_menu() -> void:
	visible = true
	is_open = true
	get_tree().paused = true
	open_sfx.play()
	default_button.grab_focus()
	

func close_menu() -> void:
	visible = false
	is_open = false
	get_tree().paused = false
	open_sfx.play()


func _on_stats_button_pressed() -> void:
	print("Stats Button Pressed")
	if stats_menu:
		stats_menu.open()
		visible = false
		is_open = false
		cursor_sfx.play()

func _on_skills_button_pressed() -> void:
	print("Skills Button Pressed")
	if skills_menu:
		skills_menu.open()
		visible = false
		is_open = false
		cursor_sfx.play()

func _on_map_button_pressed() -> void:
	print("Map Button Pressed")
	if map_menu:
		map_menu.open()
		visible = false
		is_open = false
		cursor_sfx.play()


func _on_options_button_pressed() -> void:
	print("Options Button Pressed")
	if options_menu:
		options_menu.open()
		visible = false
		is_open = false
		cursor_sfx.play()
