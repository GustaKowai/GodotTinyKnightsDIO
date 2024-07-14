extends CanvasLayer

@onready var timer_label = %timer_label
@onready var meat_label = %meat_label
@onready var coin_label = %coin_label



func _ready():
	GameManager.meat_collected.connect(on_meat_collected)
	meat_label.text = str(GameManager.meat_count)
	GameManager.coin_collected.connect(on_coin_collected)
	coin_label.text = str(GameManager.coin_count)
	
func _process(delta):
	
	timer_label.text = GameManager.time_elapsed_string
	
func on_meat_collected(value:int):
	GameManager.meat_count += value
	meat_label.text = str(GameManager.meat_count)
func on_coin_collected(value:int):
	GameManager.coin_count += value
	coin_label.text = str(GameManager.coin_count)
