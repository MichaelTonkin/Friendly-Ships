extends KinematicBody2D

var destination
var timesCollided = 0
var shooter = ""

func _ready():
	set_process(true)

func _physics_process(delta):
	var collision = move_and_collide(destination)
	
	#this is what we will do if a collision is detected
	if collision:
		print(collision.collider.name)
		if(collision.collider.name == shooter):
			return
		else:
			queue_free()
			if(collision.collider.has_method("setHealth")):
				collision.collider.setHealth(collision.collider.getHealth() - 50)
			
#function:set_direction
#description: initialises the bullet's direction
#parameters: direction - the destination the bullet will go to
func set_direction(var direction):
	destination = direction
	
#delete the bullet when it leaves the window
func _on_VisibilityNotifier2D_screen_exited():
    queue_free()

func set_shooters_name(var name):
	shooter = name