class_name Player
extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var sword_area = $"SwordArea"
@onready var hitbox_area = $HitBoxArea
@onready var health_progress_bar = $health_progress_bar

@export_category("Movement")
@export var speed = 3.0
@export_range(0,1) var lerp_smoothness = 0.5
@export_category("Sword")
@export var sword_damage:int = 20
@export_category("Ritual")
@export var ritual_damage = 10
@export var ritual_interval = 30.0
@export var ritual_scene:PackedScene
@export_category("Life")
@export var max_health = 20
@export var death_prefab:PackedScene
@export var level_up_prefab:PackedScene
var player_health = max_health/2

var atk_direction: Vector2
var input_vector = Vector2(0,0)
var is_attacking = false
var is_running = false
var was_running = false
var attack_cooldown = 0.0
var hitbox_cooldown = 0.0
var ritual_cooldown = ritual_interval/2

func _ready():
	GameManager.player = self

func _process(delta):
	
	GameManager.player_position = position
	#Obtem o vetor de input:	
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	
	#Atualiza o cd do atk
	update_atk_cd(delta)
	#Executa o ataque:
	if Input.is_action_just_pressed("attack"):
		attack()
	
	#Movimentações de sprites:
	play_run_iddle()
	if not is_attacking:
		rotate_sprite()
	#Processa o dano
	update_hitbox_detection(delta)
	
	#Atualiza a barra de vida
	update_health_bar()
	
	#Processa o ritual
	update_ritual(delta)

func _physics_process(delta):
	#Modifica a velocidade de acordo com o input:
	var target_velocity = input_vector*speed*100.0
	if is_attacking:
		target_velocity *= 0.2
	velocity = lerp(velocity,target_velocity,lerp_smoothness)
	move_and_slide()

func attack():
	#Checa se já está atacando:
	if is_attacking:
		return
	#Define como atacando:
	is_attacking = true
	attack_cooldown = 0.6
	#Escolhe o tipo de ataque aleatoriamente:
	var which_attack = randi_range(1,2)
	#Decide a direção do ataque:
	var input_axis_y = Input.get_axis("move_up","move_down")
	#Se o ataque for horizontal, define para qual lado será dado:
	if input_axis_y == 0:
		if sprite.flip_h:
			atk_direction = Vector2.LEFT
		if not sprite.flip_h:
			atk_direction = Vector2.RIGHT
		if which_attack == 1:
			animation_player.play("attack_side_1")
		if which_attack ==2:
			animation_player.play("attack_side_2")
	#Se o ataque for vertical:
	elif input_axis_y > 0:
		atk_direction = Vector2.DOWN
		if which_attack == 1:
			animation_player.play("attack_down_1")
		if which_attack ==2:
			animation_player.play("attack_down_2")
	elif input_axis_y < 0:
		atk_direction = Vector2.UP
		if which_attack == 1:
			animation_player.play("attack_up_1")
		if which_attack ==2:
			animation_player.play("attack_up_2")

func play_run_iddle():
	#Checa se o personagem está correndo
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	#Checa se está atacando:
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func rotate_sprite():
	#girar sprite:
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x <0:
		sprite.flip_h = true

func update_atk_cd(delta):
	if is_attacking:
		attack_cooldown -=delta
		if attack_cooldown <=0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func deal_damage_to_enemies():
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var enemy_direction = (enemy.position - position).normalized()
			var dot_product = enemy_direction.dot(atk_direction)
			if dot_product > 0.3:
				enemy.damage(sword_damage)

func update_hitbox_detection(delta):
	hitbox_cooldown -= delta
	if hitbox_cooldown>0: return
	hitbox_cooldown = 0.5
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy:Enemy = body
			var damage_amount = enemy.enemy_damage
			damage(damage_amount)

func update_ritual(delta):
	ritual_cooldown -=delta
	if ritual_cooldown >=0: return
	ritual_cooldown = ritual_interval
	
	var ritual = ritual_scene.instantiate()
	add_child(ritual)
	ritual.damage_ritual = ritual_damage

func damage(amount: int):
	if player_health <= 0:
		return
	player_health -=amount
	print("Player recebeu dano de ",amount,"A vida atual é de ",player_health,"/",max_health)
	#piscar o inimigo:
	modulate = Color.ORANGE
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	
	
	if player_health <=0:
		die()
		
func update_health_bar():
	health_progress_bar.max_value = max_health
	health_progress_bar.value = player_health

func heal(amount):
	player_health += amount
	if player_health > max_health:
		player_health = max_health
	print("O player recebeu cura de ",amount,"A vida total é de ",player_health,"/",max_health)
	return player_health
	
func level_up():
	print("O player subir de nivel")
	speed += 0.2
	max_health += 2
	var level_up_scene = level_up_prefab.instantiate()
	add_child(level_up_scene)

func die():
	GameManager.end_game()
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	queue_free()

