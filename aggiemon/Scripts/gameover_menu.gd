extends Control

@onready var player : Player = $"../Player"
@onready var camera : Camera2D = $"../Camera2D"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_info.curr_hp <= 0 || player.curr_hp <= 0:
		position = camera.global_position
		position.x -= 580
		position.y -= 380
		player.can_move = false
		player.speed = 0
		show()
	pass


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
