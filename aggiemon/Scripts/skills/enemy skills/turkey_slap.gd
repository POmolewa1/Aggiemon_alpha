class_name  TurkeySlap
extends Skill

func _init() -> void:
	skill_name = "Turkey Slap"
	damage = 5
	special_effect = true
	special_boost = false
	status = false

func effect(character : Character):
	var string: String = ""
	var init_def = character.defence
	character.defence /= 1.25
	string = "Lowered %s defence from %d -> %d" %[character.name, init_def, character.defence]
	return string

func set_up_button():
	var btn : PackedScene = load("res://Scenes/SkillButtons/NormalType.tscn")
	var skill_button = btn.instantiate() as SkillButton
	skill_button.init_button(self)
	skill_button.text = skill_name
	skill_button.name = skill_name
	button = skill_button
	
