class_name Narrator
extends Character

@export var animation_player : AnimationPlayer

var narrator_name : String = "Narrator"
var color : Color = Color(1, 1, 1, 1)
var spawner_id : NarratorSpawner 
var canMove : bool = true
var xp_value : int = 15

@onready var sprite : Sprite2D = $Sprite2D


func _ready() -> void:
	sprite.modulate = color
	animation_player.play("Idle")
	if self.get_parent() is NarratorSpawner:
		spawner_id = self.get_parent()


func _process(_delta):
	pass

func change_color(alt_color : Color):
	color = alt_color
