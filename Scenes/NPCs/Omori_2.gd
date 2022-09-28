extends "res://Scenes/NPCs/NPC.gd"

export var number_of_death_particles = 15

signal splatta

func hurt():
	emit_signal("splatta", number_of_death_particles)
	.hurt()

