extends "res://Scenes/Characters/Player.gd"

signal splatta

export(PackedScene) var dash_sprite

var footstep_particles = preload("res://Scenes/Particles/FootstepParticles.tscn")
var stomp_particles = preload("res://Scenes/Particles/StompParticles.tscn")

# ENUM
enum STATES {IDLE, CROUCH, WALK, RUN, JUMP, DASH, JUMP_HANGING}

export var is_dash_enabled = true
export var stop_dash_speed = 100
export var dash_speed = Vector2(2000,1000)
export var force_dash_jump_speed = 1500
export var force_hurt_jump_speed = 3000

var can_dash = true
var is_dashing = false
var dash_direction = Vector2.ZERO
var hurt_force_jump = false
var dash_force_jump = false
var boost_force_jump = false
var boost_jump_speed = 0

func _ready():
	set_max_num_of_jumps(1)
	$PooParticles.emitting = true
	
func _physics_process(delta):
	if game_over:
		return
		
	manage_dash_input()
	if is_dashing:
		manage_dash_evolution(delta)		
		velocity = move_and_slide(velocity, Vector2.UP)
		update_current_state()
		animate()
	else:
		.standard_process(delta)
		
func manage_dash_input():
	# check if the player is enabled to dash
	if not is_dash_enabled:
		return
	
	# check if the player is already dashing
	if not $Timers/DashTimer.is_stopped():
		return 
		
	# if the player has dashed and finished dashing, but it's not touched the floor => can't dash
	if is_on_floor():
		can_dash = true
	
	if not can_dash:
		return
	
	# setting x and y directions
	if Input.is_action_just_pressed("dash"):
		$Timers/DashDirectionTimer.start()

func _on_DashDirectionTimer_timeout():
	# dash left or right according to the orientation of the sprite
	dash_direction.x = get_horizontal_direction()
			
	# allow vertical dashes only while jumping
	#if is_jumping and Input.is_action_pressed("up"):
	if Input.is_action_pressed("up"):
		dash_direction.y = UP.y
		if joypad_move.x == 0:
			dash_direction.x = 0
		else:
			dash_direction.x /= 2
	else:
		dash_direction.y = 0
	
	#current_state = STATES.DASH
	velocity = Vector2(dash_speed.x * dash_direction.x, dash_speed.y * dash_direction.y) 
	set_dashing(true)		
	
func set_dashing(value):
	if value:
		is_dashing = true
		$DashCollision/DashCollisionShape.set_deferred("disabled", false)
		can_dash = false
		jump_counter = max_num_of_jumps
		modulate.a = .01
		$Timers/DashTimer.start()
		$LoSpalmerSound.play_dash_effect()		
		$AnimatedSprite.self_modulate = Color(.1,.8,1,1)
	else:
		is_dashing = false
		$DashCollision/DashCollisionShape.set_deferred("disabled", true)
		modulate.a = 1
		
func manage_dash_evolution(delta):		
	# the dash push has already been applied, this function manages the dash evolution
	velocity.x = lerp(0, velocity.x, pow(2, -10 * delta))
	velocity.y = lerp(0, velocity.y, pow(2, -10 * delta))
	
	create_dash_trail()
	
	if (abs(velocity.x) < stop_dash_speed and velocity.y > -stop_dash_speed):
		if not is_hanging:
			current_state = STATES.JUMP
		set_dashing(false)

func create_dash_trail():
	var dash_node = dash_sprite.instance()
	dash_node.global_position = global_position
	if dash_direction.x < 0:
		dash_node.flip_h = true
	else:
		dash_node.flip_h = false
	get_parent().add_child(dash_node)
	
func manage_run():
	.manage_run()
	if Input.is_action_pressed("run"):
		max_horizontal_speed = running_speed
		current_state = STATES.RUN
	else:
		max_horizontal_speed = walking_speed
		
func manage_horizontal_moves(delta):
	.manage_horizontal_moves(delta)
	
	# manages jump while crouching
	if is_crouching and is_on_floor():
		joypad_move.x = 0
	else:
		joypad_move.x = Input.get_action_strength("right") - Input.get_action_strength("left")	
		velocity.x += joypad_move.x * horizontal_acceleration * delta
	
	# if wall jumping, give a push to the opposite direction
	if is_wall_jumping:
		velocity.x = wall_jump_horizontal_push * wall_jump_direction
		is_wall_jumping = false	
	elif joypad_move.x == 0 and velocity.x != 0:
		velocity.x = lerp(0, velocity.x, pow(2, -floor_friction * delta))
		if abs(velocity.x) < velocity_is_zero_threshold:
			velocity.x = 0	
	else:
		velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
		
func stomp_on_the_floor():
	if is_on_floor() and $Timers/StompTimer.is_stopped() and not was_on_floor:
		spawn_stomp_particles()
		$LoSpalmerSound.play_stomp_effect()
		$Timers/StompTimer.start()
		
func manage_vertical_moves(_delta):
	.manage_vertical_moves(_delta)
	
	if is_on_floor():
		can_wall_jump = false
	
	manage_jumps()
		
	# manage crouch
	if Input.is_action_pressed("crouch"):
		set_crouching_state(true)
	else:
		set_crouching_state(false)
	
	stomp_on_the_floor()

func manage_jumps():
	# jump in reaction to some events like getting hurt
	if dash_force_jump: 
		dash_force_jump = false
		velocity.x = 0
		jump(force_dash_jump_speed)
	elif hurt_force_jump:
		hurt_force_jump = false
		velocity.x = dash_speed.x * (-get_horizontal_direction())
		jump(force_hurt_jump_speed)
	elif boost_force_jump:
		boost_force_jump = false
		jump(boost_jump_speed)		
	# normal jump
	elif Input.is_action_just_pressed("jump") and can_jump():
		jump()
		
func jump(speed : int = 0):
	if speed == 0:
		speed = jump_speed
	
	velocity.y = speed * UP.y
	is_jumping = true 
	
	$LoSpalmerSound.play_jump_effect()
	
	if can_wall_jump:
		is_wall_jumping = true
		can_wall_jump = false
		spawn_wall_jump_particles()
	else:
		jump_counter += 1
		is_wall_jumping = false
		
func set_crouching_state(value):
	is_crouching = value
	$StandingCollisionShape.disabled = value
	$CrouchingCollisionShape.disabled = !value
	
func update_current_state():
	if is_dashing:
		current_state = STATES.DASH
	elif is_crouching:
		current_state = STATES.CROUCH
	elif is_jumping:
		if is_hanging:
			current_state = STATES.JUMP_HANGING
		else:
			current_state = STATES.JUMP
	elif velocity.y > free_fall_speed:
		current_state = STATES.JUMP
	elif velocity.x == 0:
		current_state = STATES.IDLE
	elif abs(velocity.x) > walking_speed:
		current_state = STATES.RUN
	else: 
		current_state = STATES.WALK

func _on_WallCollision_body_entered(_body):
	if is_jumping:
		can_wall_jump = true
		wall_jump_direction = -get_horizontal_direction()
		is_hanging = true
		
func _on_WallCollision_body_exited(_body):
	can_wall_jump = false
	is_hanging = false
	
func spawn_footsteps_particles():
	$BackGroundParticles.add_child(footstep_particles.instance())

func spawn_wall_jump_particles():
	if wall_jump_direction > 0:
		$LeftSide.add_child(footstep_particles.instance())
	else:
		$RightSide.add_child(footstep_particles.instance())
	
func spawn_stomp_particles():
	$BackGroundParticles.add_child(stomp_particles.instance())
	
# manage the stomp particle effect 
func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.animation == "run" and $AnimatedSprite.frame in [0,4]:
		spawn_footsteps_particles()		

func die():
	velocity = -velocity
	emit_signal("splatta")
	get_tree().call_group("LevelSoundsEffects", "play_player_die_effect")
	get_tree().call_group("level", "change_scene_after_dying")
	queue_free()	

func hurt(strength):
	# If I just got hurt, give me some slack
	if $Timers/HurtingTimer.time_left > 0.0:
		return
		
	hurt_force_jump = true	
	player_state.hurt(strength)
	emit_signal("splatta", strength)
	
	start_after_hurt_animation_and_invulnerability()

func start_after_hurt_animation_and_invulnerability():
	$StandingCollisionShape.disabled = true
	$Timers/HurtingTimer.start()
	$HurtingAnimationPlayer.play("hurting")
	
func _on_HurtingTimer_timeout():
	$StandingCollisionShape.disabled = false
	$HurtingAnimationPlayer.stop()
	
func dash_jump_react():
	set_dashing(false)
	dash_force_jump = true
	can_dash = true

func boost_jump(jump_boost_multiplier):
	if is_dashing:
		return
	boost_jump_speed = jump_speed * jump_boost_multiplier
	boost_force_jump = true
	restore_dash()
	
func restore_dash():
	$AnimatedSprite.self_modulate = Color(1,1,1,1)
	$Timers/DashTimer.stop()
	can_dash = true
	
func _on_DashTimer_timeout():
	$AnimatedSprite.self_modulate = Color(1,1,1,1)
	can_dash = true

func force_dash_stop():
	set_dashing(false)






