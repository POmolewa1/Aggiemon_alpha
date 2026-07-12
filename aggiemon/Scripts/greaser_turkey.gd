class_name GreaserTurkey
extends Enemy


func _ready() -> void:
	color = Color(1, 1, 1, 1)
	enemy_name = "Greaser"
	xp_value = 10000
	_set_skills()

func _set_skills():
	var skill : Skill = load("res://Scripts/skills/enemy skills/turkey_slap.gd").new()
	add_skill(skill)
	skill = load("res://Scripts/skills/punch.gd").new()
	add_skill(skill)
	skill = load("res://Scripts/skills/enemy skills/greaser_punch.gd").new()
	add_skill(skill)


func select_a_skill():
	for move in move_list:
		print(move.skill_name)
	var size_of_move_list = move_list.size()
	if(size_of_move_list == 0):
		return null
	
	if ((player_info.defence / 1.5) < player_info.player_instance.defence):
		print("\n\n\n\n\n Player Speed %d < %d" %[player_info.defence / 1.5,player_info.player_instance.defence])
		return move_list[0]
	else:
		randomize()
		var choice = randi_range(0, size_of_move_list - 1)
		return move_list[choice]


func create_stats():
	max_hp = 150
	curr_hp = max_hp
	attack = 20
	special_attack = randi_range(1, 100) 
	defence = 20
	special_defence = randi_range(1, 100)
	speed = 30
