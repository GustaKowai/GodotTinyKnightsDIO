extends CanvasLayer

@onready var timer_label = %timer_label
@onready var meat_label = %meat_label
@onready var coin_label = %coin_label
@onready var exp_progress_bar = $exp_progress_bar
@export var max_exp = 100.0
@export var player_exp = 0.0
var used_xp = 0.0



func _ready():
	GameManager.meat_collected.connect(on_meat_collected)
	meat_label.text = str(GameManager.meat_count)
	GameManager.coin_collected.connect(on_coin_collected)
	coin_label.text = str(GameManager.coin_count)
	
func _process(delta):
	
	timer_label.text = GameManager.time_elapsed_string
	update_exp_bar()
	
func on_meat_collected(value:int):
	GameManager.meat_count += value
	meat_label.text = str(GameManager.meat_count)
	
func on_coin_collected(value:int):
	GameManager.coin_count += value
	coin_label.text = str(GameManager.coin_count)
	
func update_exp_bar():
	player_exp = GameManager.monsters_defeated_count - used_xp
	exp_progress_bar.max_value = max_exp
	exp_progress_bar.value = player_exp
	if player_exp >= max_exp:
		GameManager.player.level_up()
		used_xp += max_exp
		max_exp *= 1.2
