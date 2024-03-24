extends Node2D

func destruir():
	get_node("sprite").queue_free()
	get_node("shape").queue_free()
	get_node("particle").set_emitting(true)
