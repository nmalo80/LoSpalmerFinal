extends Area2D

export var wait_time = 4

func _ready():
	$ActiveTimer.wait_time = wait_time

func _on_DashPowerUp_body_entered(body):
	if not $ActiveTimer.is_stopped():
		return
		
	if body.is_in_group("player"):
		body.restore_dash()
		$ActiveTimer.start()
		set_active(false)

func _on_ActiveTimer_timeout():
	set_active(true)
	
func set_active(value : bool):
	$Sprite.visible = value
	$CollisionShape.set_deferred("disabled", not value)
