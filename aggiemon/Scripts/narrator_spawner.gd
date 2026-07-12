class_name NarratorSpawner
extends Node2D

@export var narrator_scene : PackedScene

var narrator : Narrator

func _ready() -> void:
	narrator = narrator_scene.instantiate() as Narrator
	print(self.global_position)
	add_child(narrator)
	narrator.global_position = self.global_position
	
func spawn_enemy():
	await get_tree().create_timer(10).timeout
	narrator = narrator_scene.instantiate() as Narrator
	add_child(narrator)
	narrator.global_position = self.global_position
