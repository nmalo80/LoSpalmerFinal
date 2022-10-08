extends Node2D

export var particle_scene : PackedScene
export var particle_number_jump = 10
export var particle_number_death = 40
export var random_velocity = 500.0

# signal emitted by the player when they die
const splatter_signal_name = "on_death"

var rnd = RandomNumberGenerator.new()

func _ready():
	rnd.randomize()

func on_parent_death(_parent):
	splatter(particle_number_death)

func splatter(num_of_particles_to_spawn):	
	if num_of_particles_to_spawn == 0:
		num_of_particles_to_spawn = particle_number_death
	
	# var used to own each piece of particle as we spawn it
	var spawned_particle : RigidBody2D
	
	for i in range(num_of_particles_to_spawn):
		spawned_particle = particle_scene.instance()
		spawned_particle.assign_collision_shape_position(rnd.randf_range(0, -40))
		
		if i % 4 != 0:
			spawned_particle.disable_collision_shape()
		
		get_tree().root.call_deferred("add_child",spawned_particle)
		
		spawned_particle.global_position = global_position 
		spawned_particle.linear_velocity = \
			Vector2(rnd.randf_range(-random_velocity,random_velocity),\
					rnd.randf_range(0, -random_velocity))

func _on_LoSpalmer_splatta(particles : int = 0):
	splatter(particles)

func _on_Omori_2_splatta(particles : int = 0):
	splatter(particles)

func _on_Crab_splatta(particles : int = 0):
	splatter(particles)

func _on_Omori_splatta(particles : int = 0):
	splatter(particles)
	
