extends Path2D

var sent = 1
var follow = null
var child = null


func _ready():
	follow = $follow
	child = get_node("follow")
	set_process(true)
	
func _process(delta):
	ajustesent(delta)
	
	
func ajustesent(delta):
	
	var new_offset = child.get_unit_offset() + delta*sent*0.1
	if sent == 1 and new_offset >= 0.99999:
		sent = -1
		child.set_unit_offset(0.99999)
	elif sent == -1 and new_offset <= 0:
		sent = 1
		child.set_unit_offset(0)
	else:
		child.set_unit_offset(new_offset)
	

func esmagar():
	get_node("anim").stop()
	get_node("sprite").set_texture(load("res://assets/Inimigo/slimeDead.png"))
	get_node("sprite").set_offset(Vector2(0, -7))
	get_node("shapeCorpo").queue_free()
	get_node("shape").queue_free()
	set_process(false)
