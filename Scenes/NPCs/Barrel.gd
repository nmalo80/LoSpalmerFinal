extends KinematicBody2D

var direction = 1
var speed_x = 3
var velocity = Vector2.ZERO
var rotation_speed_amplifier = 1

export var gravity = 1500
export var hurting_strength = 50

func _ready():
	pass

func _process(delta):
	velocity.y += gravity * delta
	
	if velocity.y != 0:
		if velocity.x < 0:
			velocity.x -= speed_x
		elif velocity.x > 0:
			velocity.x += speed_x
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity == Vector2.ZERO:
		direction *= -1
		velocity.x = direction * speed_x
	
	$Sprite.rotation_degrees += (velocity.x * rotation_speed_amplifier * delta)
		
	
func _on_CollisionArea_body_entered(body):
	if not body.is_in_group("player"):
		return
	
	if body.is_dashing:
		body.force_dash_stop()
		
	get_tree().call_group("player", "hurt", hurting_strength)

