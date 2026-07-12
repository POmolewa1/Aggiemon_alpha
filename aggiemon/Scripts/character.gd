class_name Character
extends CharacterBody2D


signal health_changed(new_hp: int)
signal died()

var movement_speed = 300
#stats
var level = 0
var current_xp = 0
var needed_xp = 0
var curr_hp = 0
var max_hp = 0
var attack = 0
var special_attack = 0
var defence = 0
var special_defence = 0
var speed = 0
var move_list : Array[Skill] = []


func _ready() -> void:
	if max_hp == 0:
		create_stats()
	if move_list.is_empty():
		var load_skill : Skill = load("res://Scripts/skills/punch.gd").new()
		add_skill(load_skill)
	print("Character ready:", self.name, "skills:", move_list.size())

func select_a_skill():
	var size_of_move_list = move_list.size()
	if(size_of_move_list == 0):
		return null
		
	var choice = randi_range(0, size_of_move_list - 1)
	
	return move_list[choice]

func get_stat_info():
	var stats : String
	stats = (" Lavel: %d\n XP: %d/%d\n HP: %d/%d\n Attack: %d\n Defence: %d\n Speed: %d\n" 
							%[level, current_xp, needed_xp,curr_hp, max_hp, attack, defence, speed])

	return stats

func create_stats():
	max_hp = randi_range(5, 15)
	curr_hp = max_hp
	attack = randi_range(4, 6)
	special_attack = randi_range(1, 100)
	defence = randi_range(4, 5)
	special_defence = randi_range(1, 100)
	speed = randi_range(3, 7)


func add_skill(skill : Skill):
	move_list.push_back(skill)


func take_damage(damage: int):
	curr_hp = max(0, curr_hp - damage)
	health_changed.emit(curr_hp)
	
	if curr_hp <= 0:
		died.emit()

func is_alive() -> bool:
	return curr_hp > 0
