class_name PlayerInfo
extends Node

var player_instance : Player
var level
var skill_points
var curr_hp = 0
var max_hp = 0
var attack = 0
var special_attack = 0
var defence = 0
var special_defence = 0
var speed = 0
var move_list : Array[Skill] = []

var growth_rate_default = {
	"hp" : 50,
	"attack" : 50,
	"defence" : 50,
	"speed" : 50
}
var growth_rate_aggressive = {
	"hp" : 30,
	"attack" : 80,
	"defence" : 30,
	"speed" : 60
}
var growth_rate_defensive = {
	"hp" : 60,
	"attack" : 40,
	"defence" : 70,
	"speed" : 30
}

var growth_list : Array[Dictionary] = [growth_rate_default, growth_rate_aggressive, growth_rate_defensive]


func update_player_info(player : Player):
	player_instance = player
	level = player.level
	skill_points = player.skill_points
	curr_hp = player.curr_hp
	max_hp = player.max_hp
	attack = player.attack
	special_attack = player.special_attack
	defence = player.defence
	special_defence = player.special_defence
	speed = player.speed
	move_list = player.move_list
	
func restore_player_stats():
	player_instance.max_hp = max_hp
	if player_instance.curr_hp > max_hp:
		player_instance.curr_hp = max_hp
	player_instance.attack = attack
	player_instance.defence = defence
	player_instance.speed = speed

func level_up(player : Player):
	player.level += 1
	player.needed_xp *= 1.10
	player.skill_points += 1
	player.curr_hp = player.max_hp
	var stats : Array[String] = ["hp", "attack", "defence", "speed"]
	
	for stat in stats:
		if growth_list[player.growth_rate_type][stat] >= randi_range(0, 100):
			_increase_stat(stat, player)
			print("%s has increased" %[stat])


func _increase_stat(stat : String, player : Player):
	match stat:
		"hp" : 
			player.max_hp += 15
			player.curr_hp = player.max_hp
		"attack" : player.attack += 5
		"defence" : player.defence += 5
		"speed" : player.speed += 10
	update_player_info(player)
