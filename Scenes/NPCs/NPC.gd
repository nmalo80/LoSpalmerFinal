extends KinematicBody2D

enum Direction {RIGHT = -1, LEFT = 1 }

export(Direction) var start_direction
export var speed = 100
export var gravity = 500
export var hurting_strength = 45
export var is_invincible = false

var hurting_enabled = true
var direction = 0
var velocity = Vector2.ZERO

func _ready():
	ready()
	
func ready():
	direction = start_direction
	
func _process(delta):
	process(delta)
	
func process(delta):
	velocity.y += gravity * delta	
	
	if is_on_floor():
		# turn if you bump into something
		if velocity.x == 0:
			direction *= -1
		
		velocity.x = direction * speed		
	
	$AnimatedSprite.flip_h = true if direction > 0 else false
	move()
	
func move():
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_CollisionArea_body_entered(body):
	if not body.is_in_group("player"):
		return
	
	if not is_invincible and body.is_dashing:
		body.dash_jump_react()
		hurt()
	else:
		if hurting_enabled:
			get_tree().call_group("player", "hurt", hurting_strength)
		
func hurt():
	get_tree().call_group("LevelSoundsEffects", "play_enemy_die_effect")
	queue_free()

