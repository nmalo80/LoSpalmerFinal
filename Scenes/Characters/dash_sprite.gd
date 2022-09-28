extends Sprite

func _ready():
	$DashParticles.emitting = true
	
func _physics_process(_delta):
	modulate.a = lerp(modulate.a, 0, .05)
	if modulate.a < .01:
		queue_free()
