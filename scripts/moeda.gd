extends Area2D

func _ready():
	pass # 
	
func _on_moeda_body_entered( body ):
	body.moeda()
	get_node("anim").play("coletar")
	get_node("shape").queue_free()
	yield(get_node("anim"), "animation_finished")
	queue_free()
