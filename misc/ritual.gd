extends Node2D

@export var damage_ritual = 10

@onready var area2d = $Area2D

func deal_damage():
	var bodies = area2d.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy = body
			enemy.damage(damage_ritual)
	print("ritual damage")
	pass
