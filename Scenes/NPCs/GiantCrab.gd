extends KinematicBody2D

enum Direction {RIGHT = 1, LEFT = -1 }

export var gravity = 500
export var speed = 300
export var hurting_strength = 100

signal splatta

var velocity = Vector2.ZERO
var collision = KinematicCollision2D
var collided = false
var number_of_death_particles = 500
var direction = Direction.RIGHT

#func hurt():
#	emit_signal("splatta", number_of_death_particles)
#	.hurt()

func _process(delta):
	velocity.y += gravity * delta
	velocity.x = direction * speed
	
	if not collided:
		collision = move_and_collide(velocity * delta)
		
	if collision != null:
		# ignore collisions with the floor, only act against wall collisions
		if collision.local_shape == $WallsKinematicCollision1 \
		or collision.local_shape == $WallsKinematicCollision2 \
		or collision.local_shape == $WallsKinematicCollision3:
			get_tree().call_group("tiles", "delete_tile", collision.collider.name, collision.position - collision.normal)			
			
		collided = true
		
	if collided:
		velocity = move_and_slide(velocity, Vector2.UP)
		collided = false

func _on_CollisionArea_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_group("player", "hurt", hurting_strength)		
		
func destroy():
	emit_signal("splatta", number_of_death_particles)
	get_tree().call_group("LevelSoundsEffects", "play_enemy_die_effect")
	queue_free()
