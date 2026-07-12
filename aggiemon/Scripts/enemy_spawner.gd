class_name EnemySpawner
extends Node2D

@export var enemy_scene : PackedScene

var enemy

func _ready() -> void:
	enemy = enemy_scene.instantiate() as Enemy
	#print(self.global_position)
	add_child(enemy)
	enemy.canMove = true
	enemy.not_in_battle = true
	enemy.global_position = self.global_position
	
func spawn_enemy():
	print("Started Spawn timer")
	await get_tree().create_timer(10).timeout
	enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.canMove = true
	enemy.not_in_battle = true
	enemy.global_position = self.global_position
