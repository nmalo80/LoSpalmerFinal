extends RigidBody2D

func _ready():
	pass
	
func assign_collision_shape_position(y_value):
	$ParticleCollisionShape.position.y = y_value


