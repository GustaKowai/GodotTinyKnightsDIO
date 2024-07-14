extends Sprite2D

@export var explode_prefab:PackedScene

func explode():
	if explode_prefab:
		var explosion = explode_prefab.instantiate()
		explosion.position = position
		explosion.position.y = position.y + 148.0
		get_parent().add_child(explosion)
	
	queue_free()
