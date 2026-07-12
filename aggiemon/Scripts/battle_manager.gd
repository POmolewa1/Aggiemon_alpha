class_name BattleManager
extends Node2D

signal battle_ended()
@export var battle_set_up : BattleSetUp
@export var command_container : VBoxContainer
@export var attack_button : Button
@export var back1_button : Button
@export var back2_button : Button
@export var stat_button : Button
@export var enemy_list_container : TextureRect
@export var skill_list_container : TextureRect
@export var dialogue_box : TextureRect
@export var player_stat_box : TextureRect
@export var text : Label
@export var stat_text : Label
@export var attack_sound : AudioStreamPlayer


var player : Player
var turn_order : Array[Character] = []
var enemy_list : Array[Character] = []
var xp_gain : int = 0
var target : Enemy
var active_skill : Skill

var current_turn_index : int = 0
var awaiting_target : bool = false
var turn_count : int = 0
var character_count : int = 0
var attacks_this_turn : int = 0
var double_attack : bool = false

@onready var attack_effect : PackedScene = preload("res://Scenes/attack_effect.tscn")
@onready var playerHealth: HealthBar = $"../HealthBar"
@onready var click_sound : AudioStreamPlayer = $"../click"


func connect_button_signal(button : EnemyButton):
	button.who_got_pressed.connect(_enemy_selected)


func connect_skill_signal(button : SkillButton):
	button.what_skill_pressed.connect(_skill_selected)
	click_sound.play()
	
	
func init_battle (p : Player, t : Array[Character]):
	player = p
	playerHealth.enemy = p
	turn_order = t
	enemy_list = turn_order.duplicate()
	turn_order.push_front(player)
	character_count = turn_order.size()
	_sort_by_speed()
	attack_button.pressed.connect(_show_skill_list)
	back1_button.pressed.connect(_hide_skill_list)
	back2_button.pressed.connect(_hide_enemy_list)
	stat_button.pressed.connect(_show_stat_sheet)
	
	var output : String = ""
	print("\n-----------------Turn Order-------------------")
	for characters in turn_order:
		output += characters.name + " -> "
	print(output)
	print("----------------------------------------------\n")
	
	_start_combat()


func _process(_delta):
	playerHealth.label.text = str(int(player.curr_hp)) + " / " + str(int(player.max_hp))
	if attack_button.button_pressed || back1_button.button_pressed || back2_button.button_pressed:
		click_sound.play()


func _start_combat():
	await get_tree().create_timer(2).timeout
	for enmy in enemy_list:
		enmy.global_position.y = 256
	await get_tree().create_timer(1).timeout
	current_turn_index = -1
	_next_turn()


func _skill_selected(skill : Skill):
	active_skill = skill
	_hide_skill_list()
	_show_enemy_list()
	command_container.visible = false
	click_sound.play()

func _enemy_selected(enemy_button : EnemyButton):
	click_sound.play()
	player_stat_box.visible = false
	enemy_list_container.visible = false
	var string : String
	target = enemy_button.enemy
	print("Selected: ", target.enemy_name)
	
	# Plays the universal attack effect
	var effect = attack_effect.instantiate() as AttackEffect
	effect.global_position = target.global_position
	effect.position.y -= 10
	effect.z_index = 2
	add_child(effect)
	attack_sound.play()
	target.shake()
	await get_tree().create_timer(1.0).timeout
	
	if active_skill:
		var damage = AttackSystem.execute_attack_with_skill(player, target, active_skill)
		print("did ", active_skill.damage, " damage to:", target.enemy_name, 
				" with skill:", active_skill.skill_name)
				
		string = ("did " + str(damage) + " damage to " + target.enemy_name 
					+ " with " + active_skill.skill_name)
	
	dialogue_box.visible = true
	enemy_list_container.visible = false
	command_container.visible = false
	text.text = string
	await get_tree().create_timer(1.5).timeout
	if active_skill.special_effect:
		string = active_skill.effect(target)
		text.text = string
		await get_tree().create_timer(3).timeout
	elif active_skill.special_boost:
		string = active_skill.effect(player)
		text.text = string
		await get_tree().create_timer(3).timeout
	dialogue_box.visible = false
	
	if (attacks_this_turn < 1 && player.speed > target.speed):
		attacks_this_turn += 1
		double_attack = true
	else:
		double_attack = false
	# When a target dies it is removed from the turn order and as a result we also need to
	# dynamically change the buttons in EnemyListContainer/EnemyList
	if target.curr_hp <= 0:
		var count = 0
		for enmy in turn_order:
			if enmy == target:
				turn_order.remove_at(count)
			count += 1
		count = 0
		for enmy in enemy_list:
			if enmy == target:
				enemy_list.remove_at(count)
			count += 1
		battle_set_up.update_enemy_container(enemy_list)
		target.queue_free()
		if(enemy_list.size() <= 0):
			double_attack = false
		character_count -= 1
		turn_count -= 1
		xp_gain += target.xp_value

	print("\nEnding player turn...")
	enemy_list_container.visible = false
	command_container.visible = false
	active_skill = null
	awaiting_target = false
	
	await get_tree().create_timer(1.0).timeout
	
	if (double_attack):
		string = ("Player outspeeds and attacks again")
		dialogue_box.visible = true
		enemy_list_container.visible = false
		command_container.visible = false
		text.text = string
		await get_tree().create_timer(1.5).timeout
		dialogue_box.visible = false
		_start_player_turn()
	else:
		_next_turn()


func _next_turn():
	attacks_this_turn = 0
	if _check_battle_end():
		return
		
	turn_count += 1
	if turn_count == character_count:
		_sort_by_speed()
		
	current_turn_index = (current_turn_index + 1) % turn_order.size()
	
	var current_character = turn_order[current_turn_index]
	print(current_turn_index)
	print("Current turn: " + current_character.name)
	
	awaiting_target = false
	
	if current_character is Player:
		_start_player_turn()
	elif current_character is Enemy:
		_start_enemy_turn(current_character)


func _check_battle_end() -> bool:
	var player_alive = false
	var enemies_alive = false
	
	for character in turn_order:
		if not is_instance_valid(character):
			continue
		if character is Player:
			if character.curr_hp > 0:
				player_alive = true
		elif character is Enemy:
			enemies_alive = true
	
	if not player_alive:
		_on_battle_lost()
		return true
	
	if not enemies_alive:
		_on_battle_won()
		return true
	
	return false


func _show_enemy_list():
	enemy_list_container.visible = true


func _hide_enemy_list():
	_show_skill_list()
	enemy_list_container.visible = false


func _show_skill_list():
	skill_list_container.visible = true
	command_container.visible = false
	

func _hide_skill_list():
	skill_list_container.visible = false
	command_container.visible = true


func _start_player_turn():
	print("Starting Player's turn.....\n")
	command_container.visible = true
	awaiting_target = true


func _start_enemy_turn(current_enemy : Enemy):
	
	print("Enemy turn: " + current_enemy.name)
	command_container.visible = false
	
	current_enemy.attack_movement()
	attack_sound.play()
	await get_tree().create_timer(1.0).timeout
		
	var enemy_skill : Skill = current_enemy.select_a_skill()
	var damage = AttackSystem.execute_attack_with_skill(current_enemy, player, enemy_skill)
	print("%s hits %s for %d damage!" %[current_enemy.name, player.name, damage])
	
	var string : String = ("%s uses %s for %d damage!" %[current_enemy.name, enemy_skill.skill_name, damage])
	text.text = string
	dialogue_box.visible = true
	await get_tree().create_timer(1.3).timeout
	
	if (enemy_skill.special_effect):
		string = enemy_skill.effect(player)
		text.text = string
		await get_tree().create_timer(1.7).timeout
	dialogue_box.visible = false
	
	# Characters get at most one extra turn
	if (attacks_this_turn < 1 && player.speed < current_enemy.speed):
		attacks_this_turn += 1
		double_attack = true
	else:
		double_attack = false
		
	if (double_attack):
		string = ("%s outspeeds and attacks again" %[current_enemy.name])
		dialogue_box.visible = true
		enemy_list_container.visible = false
		command_container.visible = false
		text.text = string
		await get_tree().create_timer(2.0).timeout
		dialogue_box.visible = false
		_start_enemy_turn(current_enemy)
	else:
		_next_turn()


func _on_battle_won():
	print("You won!!")
	print("Gained %d xp" %[xp_gain])
	player_info.restore_player_stats()
	if player.current_xp + xp_gain >= player.needed_xp:
		print("Level up!!!")
		var remainder : int = (player.current_xp + xp_gain) - player.needed_xp
		player.level_up()
		player.current_xp = 0
		player.current_xp += remainder
	else:
		player.current_xp += xp_gain
	await get_tree().create_timer(1.5).timeout
	battle_set_up.start_enemy_respawn()
	battle_ended.emit()


func _on_battle_lost():
	print("Defeat!")
	await get_tree().create_timer(1.5).timeout
	battle_ended.emit()
	player.curr_hp = player.max_hp
	
func _show_stat_sheet():
	click_sound.play()
	if player_stat_box.visible == false:
		player_stat_box.visible = true
	else:
		player_stat_box.visible = false
		
	stat_text.text = player.get_stat_info()


func _sort_by_speed():
	var size = turn_order.size()
	var no_swaps : bool = true
	
	for i in range(size):
		no_swaps = true
		for j in range(0, size-i-1):
			if turn_order[j].speed < turn_order[j+1].speed:
				print("%s speed is %d < %s speed is %d" %[turn_order[j].name, turn_order[j].speed, turn_order[j+1].name, turn_order[j+1].speed])
				var temp : Character = turn_order[j]
				turn_order[j] = turn_order[j+1]
				turn_order[j+1] = temp
				no_swaps = false
		if (no_swaps):
			break
			
	var output : String = ""
	print("\n-----------------Turn Order-------------------")
	for characters in turn_order:
		output += characters.name + " -> "
	print(output)
	print("----------------------------------------------\n")
	
