extends Node

@export var speed = 1.0

var enemy: Enemy
var sprite:AnimatedSprite2D

func _ready():
	enemy = get_parent()
	sprite =enemy.get_node("AnimatedSprite2D")

func _physics_process(delta):
	
	#Se der game over, parar
	if GameManager.is_game_over: return
	
	var player_position = GameManager.player_position
	var var_diff = player_position - enemy.position
	var normalize_diffe = var_diff.normalized()
	var input_vector = normalize_diffe 
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()
	#girar sprite:
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x <0:
		sprite.flip_h = true
