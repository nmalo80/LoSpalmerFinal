extends "res://Scenes/NPCs/NPC.gd"

export var number_of_death_particles = 40

signal splatta

func hurt():
	emit_signal("splatta", number_of_death_particles)
	.hurt()

func _on_CollisionArea_area_entered(_area):
	direction *= -1
