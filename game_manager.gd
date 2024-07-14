extends Node

signal  game_over

var player:Player
var player_position: Vector2
var is_game_over = false

#informações da run:
var time_elapsed = 0.0
var time_elapsed_string: String
var meat_count = 0
var coin_count = 0
var monsters_defeated_count = 0

signal meat_collected(value:int)
signal coin_collected(value:int)

func _process(delta):
	time_elapsed += delta
	var seconds_elapsed = floori(time_elapsed)
	var minutes = floori(seconds_elapsed/60.0)
	var seconds = seconds_elapsed % 60
	time_elapsed_string = "%02d:%02d" % [minutes,seconds]

func end_game():
	if is_game_over:return
	is_game_over = true
	game_over.emit()
	
func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
		
	for connection in meat_collected.get_connections():
		meat_collected.disconnect(connection.callable)
		
	for connection in coin_collected.get_connections():
		coin_collected.disconnect(connection.callable)
	
	time_elapsed = 0.0
	time_elapsed_string = "00:00"
	meat_count = 0
	coin_count = 0
	monsters_defeated_count = 0
