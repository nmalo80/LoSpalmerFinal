extends Node

var check_point = 0

func _ready():
	get_node("../GameCamera").limit_bottom = 2000
	get_node("../GameCamera").limit_left = -1000

func reset_position():
	$"../LoSpalmer".position = get_node("../CheckPoints/CheckPoint_" + str(check_point)).position
	
func assign_check_point(check_point_number):
	check_point = check_point_number
