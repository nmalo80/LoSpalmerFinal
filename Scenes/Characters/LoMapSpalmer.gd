extends KinematicBody2D

var exit_scene = preload("res://Scenes/GUI/ExitToMainScreenMenu.tscn")

const UP = Vector2.UP
const SPEED = 400

enum DIRECTIONS {NONE, LEFT, RIGHT, UP, DOWN}

var moving_direction = DIRECTIONS.NONE
var velocity = Vector2.ZERO
var allow_direction_left = false
var allow_direction_right = false
var allow_direction_up = false
var allow_direction_down = false
var current_level_number = 0

func _ready():
	var current_position = GameManager.current_character_position_in_map
	if current_position != Vector2.ZERO:
		position = current_position
		
	moving_direction = DIRECTIONS.RIGHT
	#allow_direction_right = true
	$AnimatedSprite.animation = "idle"

func _physics_process(_delta):
	if moving_direction != DIRECTIONS.NONE: 
		move_character(moving_direction)		
	elif Input.is_action_pressed("right") and allow_direction_right:
		moving_direction = DIRECTIONS.RIGHT
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("left") and allow_direction_left:
		moving_direction = DIRECTIONS.LEFT
		$AnimatedSprite.flip_h = true
	elif Input.is_action_pressed("up") and allow_direction_up:
		moving_direction = DIRECTIONS.UP
	elif Input.is_action_pressed("crouch") and allow_direction_down:
		moving_direction = DIRECTIONS.DOWN
	elif (Input.is_action_just_released("pause") or Input.is_action_just_released("ui_accept")):
		# using is_action_just_released otherwise the jump will get stuck in the next screen
		GameManager.current_character_position_in_map = position
		GameManager.go_to_level_scene(current_level_number)
	elif (Input.is_action_pressed("ui_cancel")):
		var exit_scene_instance = exit_scene.instance()
		add_child(exit_scene_instance)
		
	# warning-ignore:return_value_discarded
	move_and_slide(velocity, UP)

func move_character(_moving_direction):
	if $AnimatedSprite.animation == "idle":
		$AnimatedSprite.animation = "walk"
		
	match _moving_direction:
		DIRECTIONS.RIGHT: 
			velocity.x = SPEED
		DIRECTIONS.LEFT:
			velocity.x = -SPEED
		DIRECTIONS.UP: 
			velocity = Vector2.UP * SPEED
		DIRECTIONS.DOWN:
			velocity = Vector2.DOWN * SPEED

func stop(level_number):
	velocity = Vector2.ZERO
	moving_direction = DIRECTIONS.NONE
	current_level_number = level_number - 1
	$AnimatedSprite.animation = "idle"

