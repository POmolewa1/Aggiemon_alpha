extends Camera2D

@export var upper_bound = 100
@export var lower_bound = 600
@export var left_bound = 600
@export var right_bound = 600

@onready var player : Player = $"../Player"

func _process(_delta) -> void:
	
	if player.global_position.x <= right_bound and player.global_position.x >= -left_bound:
		global_position.x = player.global_position.x	
	
	if player.global_position.y <= lower_bound and player.global_position.y >= -upper_bound:
		global_position.y = player.global_position.y
