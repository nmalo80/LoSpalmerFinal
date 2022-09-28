extends Node2D

export var breaking_timer = 0.5
export var rebuild_timer = 2

func _ready():
	$BreakingTimer.wait_time = breaking_timer
	$RebuildTimer.wait_time = rebuild_timer

func _on_Area2D_body_entered(body):
	if $BreakingTimer.time_left == 0 and body.is_in_group("player"):
		$BreakingTimer.start()
		$KinematicBody2D/Sprite.modulate = Color(1,1,1,.4)
	
func _on_BreakingTimer_timeout():
	set_platform_visible(false)
	$BreakingBricks.emitting = true
	$RebuildTimer.start()

func _on_RebuildTimer_timeout():
	$KinematicBody2D/Sprite.modulate = Color(1,1,1,1)
	set_platform_visible(true)

func set_platform_visible(value):
	$KinematicBody2D/Sprite.visible = value
	$KinematicBody2D/CollisionShape2D.disabled = not value
	$Area2D/CollisionShape2D.disabled = not value



