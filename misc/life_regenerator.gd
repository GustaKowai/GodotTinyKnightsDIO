extends Node2D

@export var regeneration_amount = 1
@export var time_despawn = 60.0

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	
func _process(delta):
	time_despawn -= delta
	if time_despawn <= 0:
		despawn()
		time_despawn = 100.0
	if time_despawn > 90 and time_despawn <=98.0:
		queue_free()
func on_body_entered(body):
	if body.is_in_group("player"):
		var player = body
		player.heal(regeneration_amount)
		GameManager.meat_collected.emit(1)
		queue_free()
func despawn():
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.BLACK,1.0)
