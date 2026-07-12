class_name iTea
extends Skill


func _init() -> void: 
	skill_name = "iTea"
	status = false
	special_effect = false
	special_boost = true
	damage = 15

func effect(character : Character):
	var string: String = ""
	character.curr_hp += 10
	string = "That hit the spot! (+10 health to you)"
	return string
