class_name SkillButton
extends Button

signal what_skill_pressed(selected_skill : Skill)

var skill : Skill

func init_button(s : Skill):
	skill = s
	self.pressed.connect(return_self)


func return_self():
	what_skill_pressed.emit(skill)
