extends Node2D

export(PackedScene) var barrel_scene
var timer_wait_time = 0
export var max_wait_time = 1
#export var printa = false

func _ready():
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	spawn_barrel()	
	assign_random_waiting_time_to_timer()
	$SpawnTimer.start()
	
func assign_random_waiting_time_to_timer():
	timer_wait_time = (randi() % max_wait_time) + 1
#	if(printa):
#		print(timer_wait_time)
	$SpawnTimer.wait_time = timer_wait_time

func spawn_barrel():
	var barrel = barrel_scene.instance()
	get_parent().add_child(barrel)
	barrel.global_position = global_position
