extends Node2D

@export var damage_explosion = 3
@export var explode_prefab: PackedScene

@onready var area2d = $Area2D

func deal_damage():
	var bodies = area2d.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy = body
			enemy.damage(damage_explosion)
		if body.is_in_group("player"):
			var player = body
			player.damage(damage_explosion)
	pass
