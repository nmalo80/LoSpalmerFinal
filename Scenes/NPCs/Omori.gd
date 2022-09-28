extends "res://Scenes/NPCs/NPC.gd"

enum HDirection {NONE = 0, RIGHT = 1, LEFT = -1}
enum VDirection {NONE = 0, DOWN = 1, UP = -1}

export(HDirection) var start_h_direction
export(VDirection) var start_v_direction
export(bool) var can_die = true

var random_generator = RandomNumberGenerator.new()

export var number_of_death_particles = 15

signal splatta

var colors = [
	Color( 0.0, 1.0, 1.0, 1.0 ) , # blue
	Color( 1.0, 0.55, 0, 1.0 ), # dark orange
	Color( 0.55, 0.0, 0.0, 1.0 ), # dark red
	Color( 0.6, 0.8, 0.2, 1.0 ) # yellow green
	]
	
var is_enabled = true

func ready():	
	generate_character_color()
	direction = Vector2(start_h_direction, start_v_direction)	
	
func generate_character_color():
	random_generator.randomize()
	var index = random_generator.randi_range(0,colors.size()-1)
	$AnimatedSprite.modulate = colors[index]

func process(_delta):
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_CollisionArea_area_entered(_area):
	direction *= -1

func hurt():
	emit_signal("splatta", number_of_death_particles)
	if can_die:
		.hurt()
	else:
		#if it can't die, just hide it
		set_enabled(false)
		$ReenableTimer.start()

func _on_ReenableTimer_timeout():
	set_enabled(true)
	
func set_enabled(value):
	visible = value
	hurting_enabled = value
	is_enabled = value
	

