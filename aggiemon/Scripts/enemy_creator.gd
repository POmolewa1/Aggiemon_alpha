class_name EnemyCreator

var enemy_types = {
	"Turkey" = load("res://Scenes/turkey.tscn"),
	"Cooler Turkey" = load("res://Scenes/enemy.tscn"),
	"Greaser" = load("res://Scenes/greaser_turkey.tscn")
}

var enemy_class_name : String
var enemy_template : PackedScene 
var created_enemy 


func enemy_builder_default(collided_enemy : String):
	enemy_class_name = collided_enemy
	enemy_template = enemy_types[collided_enemy]
	print(enemy_class_name)
	var enemy
	var enemy_class = enemy_template.instantiate() 
	
	if enemy_class is Turkey:
		enemy = enemy_class as Turkey
		if enemy.enemy_name != "Turkey":
			enemy.enemy_name = "Turkey"
	elif enemy_class is GreaserTurkey:
		enemy = enemy_class as GreaserTurkey
		if enemy.enemy_name != "Greaser Turkey":
			enemy.enemy_name = "Greaser Turkey"
	elif enemy_class is Enemy:
		enemy = enemy_class as Enemy
		
	enemy.canMove = false
	enemy.not_in_battle = false
	enemy.name = enemy.enemy_name
	enemy.create_stats()
	return enemy
	
func enemy_builder():
	var num = randi_range(0, 1)
	match num:
		#0 : created_enemy = _enemy_type_1()
		#1 : created_enemy = _enemy_type_2()
		0 : created_enemy = _enemy_type_1()
		1 : created_enemy = _enemy_type_2()
	return created_enemy
	
func _enemy_type_1():
	enemy_template = enemy_types["Turkey"]
	var enemy = enemy_template.instantiate() as Turkey
	enemy.canMove = false
	enemy.not_in_battle = false
	enemy.change_color(Color("4400ff"))
	enemy.name = "Turkey"
	enemy.create_stats()
	return enemy

func _enemy_type_2():
	enemy_template = enemy_types["Cooler Turkey"]
	var enemy = enemy_template.instantiate() as Enemy
	enemy.canMove = false
	enemy.not_in_battle = false
	#enemy.change_color(Color("b000b0ff"))
	enemy.name = enemy.enemy_name
	enemy.create_stats()
	return enemy

func _build_boss():
	enemy_template = enemy_types["Greaser"]
	var enemy = enemy_template.instantiate() as GreaserTurkey
	enemy.canMove = false
	enemy.not_in_battle = false
	enemy.name = enemy.enemy_name
	enemy.create_stats()
	return enemy
	
