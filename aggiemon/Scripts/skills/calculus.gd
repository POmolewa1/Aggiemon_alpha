class_name Calculus
extends Skill


func _init() -> void: 
	skill_name = "Calculus"
	status = false
	special_effect = true
	special_boost = false
	damage = 20

func effect(character : Character):
	var string: String = ""
	var init_defense = character.defence
	character.defence /= 1.35
	string = "%s has no clue was a greek alphabet is. (defence %d -> %d)" %[character.name, init_defense, character.defence]
	return string
