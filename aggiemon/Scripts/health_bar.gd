class_name HealthBar
extends ProgressBar

@export var enemy : Character
@export var label : Label
# Called when the node enters the scene tree for the first time.

func set_up_health_bar():
	if enemy:
		enemy.health_changed.connect(_on_health_changed)
		_on_health_changed(enemy.curr_hp)

func _on_health_changed(_new_hp: int = 0):
	self.max_value = enemy.max_hp
	self.value = enemy.curr_hp
	
	var hp_percent = (enemy.curr_hp / enemy.max_hp) * 100
	var fill_style = self.get_theme_stylebox("fill") as StyleBoxFlat
	if fill_style:
		if hp_percent > 60:
			fill_style.bg_color = Color(0, 1, 0, 1) 
		elif hp_percent > 30:
			fill_style.bg_color = Color(1, 1, 0, 1) 
		else:
			fill_style.bg_color = Color(1, 0, 0, 1)  
	
	label.text = str(int(self.value)) + " / " + str(int(self.max_value))

func update_health_bar():
	self.max_value = enemy.max_hp
	self.value = enemy.curr_hp
	
	var hp_percent = (enemy.curr_hp / enemy.max_hp) * 100
	var fill_style = self.get_theme_stylebox("fill") as StyleBoxFlat
	if fill_style:
		if hp_percent > 60:
			fill_style.bg_color = Color(0, 1, 0, 1)  
		elif hp_percent > 30:
			fill_style.bg_color = Color(1, 1, 0, 1)  
		else:
			fill_style.bg_color = Color(1, 0, 0, 1)  
	
	label.text = str(int(self.value)) + " / " + str(int(self.max_value))
