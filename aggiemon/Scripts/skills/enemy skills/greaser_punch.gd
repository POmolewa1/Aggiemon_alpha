class_name GreaserPunch
extends Skill

var lines = {
	0 : "Is that all you've got? HAHAHAHAHAAHAH!!!!!",
	1 : "Did that hurt? WELL TOO BAD!!",
	2 : "Don't give up now! were just getting started."
}

func _init() -> void:
	skill_name = "Greaser Punch"
	damage = 25
	special_effect = true
	special_boost = false

func effect(character : Character):
	randomize()
	var _void = character
	var index = randi_range(0,2)
	return lines[index]
