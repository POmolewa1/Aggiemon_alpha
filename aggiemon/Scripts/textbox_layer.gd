extends CanvasLayer


@onready var textbox_container = $Textbox
@onready var label = $Textbox/Panel/MarginContainer/HBoxContainer/Label
@onready var text_sfx: AudioStreamPlayer = $TextSFX
@onready var tween = get_tree().create_tween()

@export var num_visible_character_per_loop = 2
@export var speed_of_character_read = 0.03

func _ready() -> void:
	hide_textbox()

func hide_textbox():
	label.text = ""
	textbox_container.hide()
	
func show_textbox():
	textbox_container.show()
	
func add_text(text):
	label.text = text
	label.visible_ratio = 0.0
	show_textbox()
	for i in label.text.length():
		label.visible_characters = i + num_visible_character_per_loop
		await get_tree().create_timer(speed_of_character_read).timeout
		if text_sfx:
			if text_sfx.playing:
				text_sfx.stop()
			text_sfx.play()
	
	# Calculate display time based on text length (roughly 0.02 seconds per character, minimum 2 seconds)
	var display_time = max(4.0, text.length() * 0.02)
	await get_tree().create_timer(display_time).timeout 
	hide_textbox()
