class_name EnemyButton
extends Button

signal who_got_pressed(button : Button)

var enemy : Enemy
var enemy_name : String = "DEFUALT"

func init_button(enmy : Enemy, nme : String):
	enemy = enmy
	enemy_name = nme
	self.pressed.connect(return_self)
	
func return_self():
	who_got_pressed.emit(self)
