class_name BattleSetUp
extends Node2D

@export var default_music : AudioStreamPlayer
@export var boss_theme : AudioStreamPlayer
#middle 559x 256y
var pos := Vector2i(159, 256)

var player : Player
var num : int
var enemy_creator : EnemyCreator = load("res://Scripts/enemy_creator.gd").new()
var turn_order : Array[Character] = []
var spawner_id : EnemySpawner

@onready var battle_manager : BattleManager = $BattleManager
@onready var enemy_list : HBoxContainer = $EnemyListContainer/EnemyList
@onready var skill_list : GridContainer = $SkillListContainer/SkillList


func start_enemy_respawn():
	if spawner_id:
		spawner_id.spawn_enemy()


func update_enemy_container(array : Array[Character]):
	turn_order = array
	for child in enemy_list.get_children():
		child.queue_free()
	call_deferred("_update_enemy_list")


func play_boss_theme():
	default_music.stop()
	boss_theme.play()

func _init_characters(player_character : Player, collided_enemey):
	if collided_enemey is GreaserTurkey:
		play_boss_theme()
	player = player_character
	spawner_id = collided_enemey.spawner_id
	battle_manager.playerHealth.set_up_health_bar()
	num = (randi_range(1, 2))
	_create_extra_enemies(num, collided_enemey.enemy_name)


func _create_extra_enemies(number : int, default_enemy : String):
	
	var initial_enemy = enemy_creator.enemy_builder_default(default_enemy)
	turn_order.push_back(initial_enemy)
	if default_enemy != "Greaser":
		for i in range(number):
			var created_enemy  = enemy_creator.enemy_builder()
			turn_order.push_back(created_enemy)
	_place_enemies()


func _place_enemies():
	for enemies in turn_order:
		add_child(enemies)
		enemies.unhide_healthbar()
		enemies.health_bar.set_up_health_bar()
		enemies.z_index = 1
		enemies.scale = Vector2(2,2)
		enemies.global_position = pos
		enemies.z_index = 1
		enemies.canMove = false
		enemies.not_in_battle = false
		if turn_order.size() == 1:
			enemies.global_position = Vector2i(559, 256)
		pos.x += 400
	_update_enemy_list()
	_update_skill_list()
	
	battle_manager.init_battle(player, turn_order)


func _update_enemy_list():
	var enemy_number : int = 2
	for enemies in turn_order:
		var button : PackedScene = load("res://Scenes/EnemyButton.tscn")
		var enemy_button = button.instantiate() as EnemyButton
		enemy_button.init_button(enemies, enemies.enemy_name)
		enemy_button.name = enemy_button.enemy_name
		enemy_button.text = enemy_button.enemy_name
		enemy_list.add_child(enemy_button)
		if enemy_button.name != enemies.enemy_name:
			var new_name : String = enemy_button.enemy_name + " " + str(enemy_number)
			enemy_button.enemy_name = new_name
			enemy_button.name = new_name
			enemies.name = new_name
			enemy_button.text = new_name
			enemy_number += 1
			
		battle_manager.connect_button_signal(enemy_button)


func _update_skill_list():
	for move in player.move_list:
		move.set_up_button()
		skill_list.add_child(move.button)
		battle_manager.connect_skill_signal(move.button)
