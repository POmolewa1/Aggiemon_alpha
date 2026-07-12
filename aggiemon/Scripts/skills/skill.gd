@abstract class_name Skill

var skill_name : String = "SKILL NAME"
var button : SkillButton
var damage : int 
var special_effect : bool
var special_boost : bool
var status : bool 

@abstract func effect(character : Character)

func set_up_button():
	var btn : PackedScene = load("res://Scenes/SkillButtons/NormalType.tscn")
	var skill_button = btn.instantiate() as SkillButton
	skill_button.init_button(self)
	skill_button.text = skill_name
	skill_button.name = skill_name
	button = skill_button
