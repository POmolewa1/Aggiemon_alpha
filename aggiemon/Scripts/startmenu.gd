extends Control

@onready var player : Player = $"../Player"
@onready var camera : Camera2D = $"../Camera2D"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.can_move = false
	$Credits.hide()
	
func _hide_start_menu() -> void:
	$Panel2.hide()
	$VBoxContainer.hide()

func _show_start_menu() -> void:
	$Panel2.show()
	$VBoxContainer.show()

func _on_start_pressed() -> void:
	print("_on_start_pressed")
	player.can_move = true
	hide()


func _on_exit_pressed() -> void:
	print("_on_exit_pressed")
	get_tree().quit()


func _on_credits_pressed() -> void:
	_hide_start_menu()
	$Credits.show()


func _on_back_pressed() -> void:
	_show_start_menu()
	$Credits.hide()
