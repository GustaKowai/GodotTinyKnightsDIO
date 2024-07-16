class_name Enemy
extends CharacterBody2D

@export_category("Fight")
@export var enemy_health = 10
@export var death_prefab:PackedScene
@export var enemy_damage = 1
@export var buff_time = 30.0
@export_category("Drops")
@export var items:Array[PackedScene]
@export_range(0,1) var drop_rate = 0.5
@export var drop_chances: Array[float]
var damage_digit_prefab:PackedScene
@onready var damage_digit_marker = $damage_digit_marker

func _ready():
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")
	var buff = randi_range(0,floori(GameManager.time_elapsed/buff_time))
	enemy_health *= 1+(buff/10.0)
	print("A vida do atual inimigo é de ",enemy_health," e o buff foi de ",buff)

func damage(amount: int):
	enemy_health -=amount
	print("Inimigo recebeu dano de ",amount,"A vida total é de ",enemy_health)
	#piscar o inimigo:
	modulate = Color.ORANGE
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	
	#Aparecer o dano:
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = position
	
	get_parent().add_child(damage_digit)
	#tomar um backlash quando recebe dano:
	#var player_position = GameManager.player_position
	#var var_diff = player_position - position
	#var normalize_diffe = var_diff.normalized()
	#var input_vector = normalize_diffe 
	#position -= input_vector*100
	
	if enemy_health <=0:
		drop_item()
		die()
		
func drop_item():
	if not items:
		print ("Não tenho drop")
		return
	if randf() > drop_rate: return
	var item = get_random_drop_item().instantiate()
	item.position = position
	get_parent().add_child(item)
	
func get_random_drop_item():
	var max_chance = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
		
	var random_value = randf()*max_chance
	
	var item_chooser = 0.0
	for i in items.size():
		var droped_item = items[i]
		var drop_chance = drop_chances[i] if i <drop_chances.size() else 1.0
		if random_value <=drop_chance + item_chooser:
			return droped_item
		item_chooser += drop_chance
	return items[0]
	
func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		
	GameManager.monsters_defeated_count +=1
	
	queue_free()
