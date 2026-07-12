class_name AttackEffect
extends Sprite2D

@onready var animation_player : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("effect")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var _void = anim_name
	self.queue_free()
