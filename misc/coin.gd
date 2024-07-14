extends Node2D

@export var coin_value = 5

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
	
func on_body_entered(body):
	print(body)
	if body.is_in_group("player"):
		var player = body
		GameManager.coin_collected.emit(coin_value)
		queue_free()
		
	pass
