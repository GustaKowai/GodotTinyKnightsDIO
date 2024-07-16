extends Node

var enemy: Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	enemy = get_parent()
	enemy.enemy_health = GameManager.player.ritual_damage*2
