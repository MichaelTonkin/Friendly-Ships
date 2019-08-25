extends KinematicBody2D

var destination

func _ready():
	set_process(true)

func _physics_process(delta):
	move_and_collide(destination)
	
#function:set_direction
#description: initialises the bullet's direction
#parameters: direction - the destination the bullet will go to
func set_direction(var direction):
	destination = direction
