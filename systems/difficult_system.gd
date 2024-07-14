extends Node

@export var mob_spawner:MobSpawner
@export var initial_spawn_rate = 60.0
@export var mobs_increase_per_minute = 10.0
@export var wave_duration = 20.0
@export var break_intensity = 0.5
var time = 0.0

func _process(delta):
	#Se der game over, parar
	if GameManager.is_game_over: return
	#Implementar temporizador
	time += delta
	
	var cos_wave = cos(time*TAU/wave_duration)
	var wave_factor = remap(cos_wave,-1,1,break_intensity,1)
	
	var spawn_rate = initial_spawn_rate + mobs_increase_per_minute*(time/60.0)
	spawn_rate *=wave_factor
	
	mob_spawner.mobs_per_minute = spawn_rate
