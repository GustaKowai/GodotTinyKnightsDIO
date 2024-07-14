class_name GameOverUI
extends CanvasLayer

@onready var time_label = %TimeLabel
@onready var monster_label = %MonsterLabel
@onready var coin_label = %GoldLabel

@export var restart_delay = 1.5
var restart_cooldown: float

func _ready():
	time_label.text = GameManager.time_elapsed_string
	monster_label.text = str(GameManager.monsters_defeated_count)
	coin_label.text = str(GameManager.coin_count)
	
	restart_cooldown = restart_delay
	
func _process(delta):
	
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		if Input.is_action_just_pressed("attack"):
			restart_game()
		
func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
	pass
	
