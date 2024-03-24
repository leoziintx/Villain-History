extends Node2D

onready var platform = $plataform
onready var tween = $Tween

export var speed = 3.0
export var horizontal = true
export var distance = 192

const WAIT_DUARATION = 1.0


var possit = null
var pos_array = []

func _start_tween():
	var move_direction = Vector2.RIGHT * distance if horizontal else Vector2.UP * distance
	var duration = move_direction.length() / float(speed * 16)
	tween.interpolate_property(
		platform, "position", Vector2.ZERO, move_direction, duration, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, WAIT_DUARATION
	)
	tween.interpolate_property(
		platform, "position", move_direction, Vector2.ZERO, duration, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + WAIT_DUARATION * 2
	)
	tween.start()	
	
func _ready():
	possit = $position
	pos_array = possit.get_children()
	for slot in pos_array:
		print(slot)
	
	_start_tween()
