extends Node2D

# moves the platform to the points specified in the move_to array
# every move's duration is specified in the duration array
# every delay is specified in the idle_duration array

export var move_to : Array
export var idle_duration : Array
export var duration : Array
export var smoothness = 0.1

onready var platform = $Platform
onready var move_tween = $MoveTween

var follow = Vector2.ZERO

func _ready():			
	init_tween()

func _physics_process(_delta):
	platform.position = platform.position.linear_interpolate(follow, smoothness)
	
func init_tween():
	var delay = 0
	var from = Vector2.ZERO
	
	delay = 0.0
	for i in range(move_to.size()):
		delay += idle_duration[i]
		interpolate(from, move_to[i], duration[i], delay)
		delay += duration[i] 
		from = move_to[i]
	
	if duration.size() > 0 and idle_duration.size() > 0:
		interpolate(from, Vector2.ZERO, \
					duration[-1], \
					delay + idle_duration[-1] )
	
		move_tween.start()

func interpolate(from, to, int_duration, delay):
	move_tween.interpolate_property(\
			self, "follow", from, to, int_duration, \
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)

