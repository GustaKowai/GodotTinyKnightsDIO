class_name MobSpawner
extends Node2D

@export var creatures:Array[PackedScene]
var mobs_per_minute = 60.0

@onready var path_follow_2d = %MobPath

var cooldown = 0

func _process(delta):
	#Se der game over, parar
	if GameManager.is_game_over: return
	
	#Cooldown entre invocação de monstros:
	cooldown -= delta
	if cooldown>0:return

	var interval = 60.0/mobs_per_minute
	cooldown = interval
	
	#Instanciar uma criatura aleatória:
	var creature_index = randi_range(0,creatures.size()-1)
	var creature_scene = creatures[creature_index]
	print(creature_index)
	var creature = creature_scene.instantiate()
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	var result = world_state.intersect_point(parameters,1)
	if not result.is_empty():return
	creature.position = point
	get_parent().add_child(creature)
	
func get_point():
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position

