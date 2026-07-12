class_name Enemy
extends Character

@export var health_bar : HealthBar
@export var animation_player : AnimationPlayer

var enemy_name : String = "Cooler Turkey"
var color : Color = Color(1,1,1,1)
var spawner_id : EnemySpawner
var canMove : bool = false
var not_in_battle : bool = false
var xp_value : int = 15
var max_y_pos : float
var min_y_pos : float
var max_x_pos : float
var min_x_pos : float

@onready var sprite : Sprite2D = $Sprite2D


func _ready() -> void:
	sprite.modulate = color
	max_x_pos = self.global_position.x + 100.0
	min_x_pos = self.global_position.x - 100.0
	max_y_pos = self.global_position.y + 100.0
	min_y_pos = self.global_position.y - 100.0
	animation_player.play("Idle")
	if self.get_parent() is EnemySpawner:
		spawner_id = self.get_parent()
	_set_skills()


func _process(delta):
	if canMove:
		canMove = false
		overworld_enemy_movement()
		await get_tree().create_timer(7.0).timeout
		canMove = true
	move_and_slide()
	_tether(delta)

func _tether(delta : float):
	if not_in_battle:
		var move_to : float
		if self.global_position.x > max_x_pos:
			var distance = self.global_position.x - max_x_pos
			move_to = lerp(self.global_position.x, self.global_position.x - distance, 3 * delta)
			self.global_position.x = move_to
		elif self.global_position.x < min_x_pos:
			var distance = min_x_pos - self.global_position.x
			move_to = lerp(self.global_position.x, self.global_position.x + distance, 3 * delta)
			self.global_position.x = move_to
		if self.global_position.y > max_y_pos:
			var distance = self.global_position.y - max_y_pos
			move_to = lerp(self.global_position.y, self.global_position.y - distance, 3 * delta)
			self.global_position.y = move_to
		elif self.global_position.y < min_y_pos:
			var distance = min_y_pos - self.global_position.y
			move_to = lerp(self.global_position.y, self.global_position.y + distance, 3 * delta)
			self.global_position.y = move_to
	else:
		if self.global_position.x > 350 and self.global_position.x < 551:
			self.global_position.x = 559
			self.global_position.y = 256
		
	
func change_color(alt_color : Color):
	color = alt_color


func unhide_healthbar():
	health_bar.visible = true
	health_bar.update_health_bar()


func choose_attack():
	var targets = get_tree().get_nodes_in_group("player")
	if targets.size() > 0:
		return targets[0]
	return null


func _set_skills():
	var skill1 : Skill = load("res://Scripts/skills/punch.gd").new()
	self.add_skill(skill1)

func shake():
	var original_pos : Vector2 = self.global_position
	var tween = create_tween()
	
	tween.tween_property(self, "position", original_pos + Vector2(20,0), 0.05)
	tween.tween_property(self, "position", original_pos, 0.05)

func attack_movement():
	var original_pos : Vector2 = self.global_position
	var tween = create_tween()
	
	tween.tween_property(self, "position", original_pos + Vector2(0,40), 0.15)
	tween.tween_property(self, "position", original_pos, 0.15)

func overworld_enemy_movement():
	var x_dir = randi_range(-1, 1)
	var y_dir = randi_range(-1, 1)
	velocity.x = 100 * x_dir
	velocity.y = 100 * y_dir

	await get_tree().create_timer(3.0).timeout
	velocity = Vector2.ZERO
	
