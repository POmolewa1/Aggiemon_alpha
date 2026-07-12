extends Control

@export var character: Character 
@export var overworld_menu: PanelContainer

@export var skill_list: ItemList 
@export var info_label: Label

var skills: Array[Skill] = []

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS


func open() -> void:
	visible = true
	_populate_skill_list()
	info_label.text = ""


func close() -> void:
	visible = false
	if overworld_menu:
		overworld_menu.visible = true
		overworld_menu.is_open = true
		if overworld_menu.default_button:
			overworld_menu.default_button.grab_focus()

func _populate_skill_list() -> void:
	print("skill_list export is:", skill_list)
	skill_list.clear()
	skills.clear()

	print("SkillsMenu for", character.name, 
		  "move_list size =", character.move_list.size())
	if character == null:
		info_label.text = "ERROR: No character assigned."
		return
	
	if character.move_list.is_empty():
		info_label.text = "No skills learned yet."
		return
	
	for skill in character.move_list:
		skills.append(skill)
		skill_list.add_item(skill.skill_name)
	
func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("menu"):
		close()
		get_viewport().set_input_as_handled()


func _on_skill_list_item_selected(index: int) -> void:
	if index < 0 or index >= skills.size():
		return
	
	var skill: Skill = skills[index]
	var text := "%s\n\nDamage: %d\nStatus Move: %s\nSpecial Effect: %s" % [
		skill.skill_name,
		skill.damage,
		"Yes" if skill.status else "No",
		"Yes" if skill.special_effect else "No"
	]
	info_label.text = text
