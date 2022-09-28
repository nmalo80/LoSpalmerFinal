extends KinematicBody2D

# constants
const UP = Vector2.UP

# Signals
signal animate

# export variables to be tweaked by the player's instance
export var horizontal_acceleration = 2000
export var walking_speed = 200
export var running_speed = 400
export var gravity = 500
export var jump_speed = 2000
export var max_vertical_speed = 400
export var jump_termination_multiplier = 3 # used for tap-jumps
export var floor_friction = 10
export var wall_jump_horizontal_push = 800

# variables
var joypad_move = Vector2.ZERO
var initial_position = Vector2.ZERO
var was_on_floor = true
var velocity = Vector2.ZERO
var jump_counter = 0
var is_jumping = false
var is_crouching = false
var max_num_of_jumps = 2 
var current_state = 0
var max_horizontal_speed = 0
var velocity_is_zero_threshold = 30
var can_wall_jump = false
var is_wall_jumping = false
var wall_jump_direction = 1
var free_fall_speed = 80
var is_hanging = false
var player_state
var game_over = false

var snap = Vector2(0, 32)
var is_on_platform = true
onready var platform_detector = $PlatformDetectorRayCast

func _ready():
	initial_position = get_global_position()
	player_state = $PlayerState
	
func standard_process(delta):
	apply_gravity(delta)
	manage_run()	
	manage_vertical_moves(delta)
	manage_horizontal_moves(delta)
	move_and_slide_and_coyote_timer()		
	update_current_state()
	animate()

func move_and_slide_and_coyote_timer():
	was_on_floor = is_on_floor()
	
	# snap allows the character to move on slopes
	if is_jumping:
		snap = Vector2()
	else:
		snap = Vector2(0, 32)
	#velocity = move_and_slide_with_snap(velocity, snap, UP, true)
	
	is_on_platform = platform_detector.is_colliding()
	velocity = move_and_slide_with_snap(velocity, snap, UP, not is_on_platform)
		
	if was_on_floor and not is_on_floor():
		$Timers/CoyoteTimer.start()

func manage_run():
	pass

func manage_dash_input():
	pass
	
func apply_gravity(delta):
	if is_on_floor():
		velocity.y = 1
		jump_counter = 0
		is_jumping = false
	# tap jump
	elif jump_counter == 1 and velocity.y < 0 and not Input.is_action_pressed("jump"):
		velocity.y += gravity * jump_termination_multiplier * delta
	else:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_vertical_speed)

func manage_vertical_moves(_delta): 
	pass

func manage_horizontal_moves(_delta):
	pass

func animate():
	emit_signal("animate", velocity, current_state)

func update_current_state():
	pass
	
func can_jump():
	if can_wall_jump:
		return true
	if not $Timers/CoyoteTimer.is_stopped():
		return true
	if is_jumping:
		return jump_counter < max_num_of_jumps
	return is_on_floor() 

func set_floor_friction(value):
	floor_friction = value

func get_horizontal_direction():
	if $AnimatedSprite.flip_h:
		return -1
	else: 
		return 1

func set_max_num_of_jumps(value):
	max_num_of_jumps = value

func hurt(_strength):
	pass
	
func die():
	pass

func dash_jump_react():
	pass

func boost_jump(_jump_boost_multiplier):
	pass

func coin_collected():
	player_state.get_coin()

func zuparicu_collected():
	player_state.get_zuparicu()

func finish_level(finish_game = false):
	velocity = Vector2.ZERO
	game_over = true
	if finish_game:
		print("congrats!")
