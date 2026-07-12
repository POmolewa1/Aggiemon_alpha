extends Area2D


var connected : bool = false;
var shop_toggle : bool = true
@export var shop : Control

func _ready():
	self.body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	
func _process(_delta):
	if connected:
		if Input.is_action_just_pressed("shop"):
			if shop_toggle:
				shop.open()
			else:
				shop.close()
			shop_toggle = not shop_toggle
	
	

func _on_body_entered(body):
	if body is Player:
		connected = true
	
func _on_body_exited(body):
	if body is Player:
		connected = false
