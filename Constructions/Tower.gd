extends Node2D

@export var coin_cost = 10
@export var sword_buff = 10
@onready var animation_player = $AnimationPlayer
@onready var bonus_sword = %BonusSword
@onready var cost_label = %CostLabel
@export var destroy_time = 60.0

func _ready():
	$Area2D.body_entered.connect(on_body_entered)
	cost_label.text = str(-coin_cost)
	bonus_sword.text = "+%d"%sword_buff
	
func _process(delta):
	destroy_time -=delta
	if destroy_time <= 0:
		animation_player.play("destroy")
	
	
func on_body_entered(body):
	if body.is_in_group("player"):
		if GameManager.coin_count >=coin_cost:
			var player = body
			GameManager.coin_collected.emit(-coin_cost)
			player.sword_damage +=sword_buff
			animation_player.play("sell")
