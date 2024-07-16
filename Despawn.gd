extends Node

@export var distance_range = 200.0

var enemy: Enemy
var sprite:AnimatedSprite2D

func _ready():
	enemy = get_parent()
	
func _physics_process(delta):
	
	#Se der game over, parar
	if GameManager.is_game_over: return
	
	var player_position = GameManager.player_position
	var var_diff = player_position - enemy.position
	if var_diff.length() > distance_range:
		enemy.die()
	
