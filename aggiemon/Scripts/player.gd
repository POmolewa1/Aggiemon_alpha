class_name Player
extends Character

enum growth_type {
	default = 0,
	aggressive = 1,
	defensive = 2
}

@export var animation_player : AnimationPlayer
@export var player_speed = 300
@export var level_label : Label

var skill_points = 0
var growth_rate_type = growth_type.default
var facing_left : bool = true
var idling : bool = false
var in_battle : bool = false
var can_move : bool = true
var can_level : bool = true

@onready var sprite : Sprite2D = $Student


	
func set_battle_mode(enabled: bool):
	in_battle = enabled

func _process(_delta: float) -> void:
	if in_battle:
		self.velocity = Vector2(0,0)
		return
	
	var input_horizontal = Input.get_action_strength("right") - Input.get_action_strength("left")
	var input_vertical = Input.get_action_strength("up") - Input.get_action_strength("down")
	
	if can_move:
		self.velocity.x = player_speed * input_horizontal
		self.velocity.y = -player_speed * input_vertical
		self.velocity = velocity.limit_length(player_speed)
		if(Input.is_action_pressed("up")):
			animation_player.play("Walk_Up")
		elif(Input.is_action_pressed("down")):
			animation_player.play("Walk_down")
		elif(Input.is_action_pressed("right")):
			sprite.flip_h = true
			facing_left = false
			idling = false
			animation_player.play("Walk_X") 
			#print(sprite.flip_h) 
		elif(Input.is_action_pressed("left")):
			sprite.flip_h = false
			facing_left = true
			idling = false
			animation_player.play("Walk_X")
			#print(sprite.flip_h) 
		else:
			if facing_left:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
			if not idling:
				animation_player.play("Idle")
				idling = true
	else:
		animation_player.play("Idle")
		idling = true
	if Input.is_action_just_released("up"):
		animation_player.play("Idle")
		idling = true
	if Input.is_action_just_released("down"):
		animation_player.play("Idle")
		idling = true
	var both_pressed = Input.is_action_pressed("Level Up") and Input.is_action_pressed("ui_up")
	if both_pressed and can_level:
		level_up()
	if Input.is_key_pressed(KEY_0):
		curr_hp = 0
	move_and_slide()

func create_stats():
	level = 1
	current_xp = 0
	needed_xp = 45
	max_hp = 100
	curr_hp = max_hp
	attack = 5
	special_attack = randi_range(1, 100)
	defence = 5
	special_defence = randi_range(1, 100)
	speed = 5
	var num = randi_range(0,2)
	match num:
		0: growth_rate_type = growth_type.default
		1: growth_rate_type = growth_type.aggressive
		2: growth_rate_type = growth_type.defensive
	print(growth_rate_type)
	player_info.update_player_info(self)

func level_up():
	can_level = false
	player_info.level_up(self)
	level_label.visible = true	
	await get_tree().create_timer(5).timeout
	level_label.visible = false
	can_level = true
