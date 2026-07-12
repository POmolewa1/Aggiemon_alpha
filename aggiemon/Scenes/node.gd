extends Node

@onready var greaserturkey = $"../../GreaserTurkey"
@onready var labelwin	= $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	labelwin.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if greaserturkey == null:
		labelwin.show()
