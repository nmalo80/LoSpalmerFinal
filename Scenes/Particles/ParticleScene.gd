extends RigidBody2D
	
func assign_collision_shape_position(y_value):
	$ParticleCollisionShape.position.y = y_value

func disable_collision_shape():
	$ParticleCollisionShape.disabled = true

