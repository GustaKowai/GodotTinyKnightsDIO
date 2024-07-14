extends Node2D

@export var regeneration_amount = 1

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
	
func on_body_entered(body):
	if body.is_in_group("player"):
		var player = body
		player.heal(regeneration_amount)
		GameManager.meat_collected.emit(1)
		queue_free()
		
	pass
