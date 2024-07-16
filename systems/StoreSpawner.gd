class_name StoreSpawner
extends Node2D

@export var stores:Array[PackedScene]
var stores_per_minute = 3.0
var cooldown = 0

func _process(delta):
	#Se der game over, parar
	if GameManager.is_game_over: return
	
	#Cooldown entre invocação de monstros:
	cooldown -= delta
	if cooldown>0:return

	var interval = 60.0/stores_per_minute
	cooldown = interval
	
	#Instanciar uma criatura aleatória:
	var store_index = randi_range(0,stores.size()-1)
	if store_index == 2:
		if GameManager.player.ritual_interval<=15.0:
			print("Opa, não da para ficar com menos cooldown nisso.")
			store_index = randi_range(0,1)
	var store_scene = stores[store_index]
	print("A loja ",store_index," foi construida!")
	var store = store_scene.instantiate()
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	var result = world_state.intersect_point(parameters,1)
	if not result.is_empty():return
	store.position = point
	get_parent().add_child(store)
	
func get_point() -> Vector2:
	var point:Vector2
	point.x = randi_range(-1612,3018)
	point.y = randi_range(-1291, 1700)
	return point

