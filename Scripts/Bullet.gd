extends KinematicBody2D

var destination
var timesCollided = 0
var shooter
var alive1
var alive2
var explos_1 = preload("res://Textures/Explosions/Explosion_1.png")

func _ready():
	set_process(true)

func _physics_process(delta):
	var collision = move_and_collide(destination)
	
	#this is what we will do if a collision is detected
	if collision:
		#check to see if an enemy was shooting
		#alive1 = shooter, alive2 = target
		alive1 = weakref(shooter)
		alive2 = weakref(collision.collider)
		
		#if another enemy ship has been hit, ignore it. Otherwise, reduce the target's health
		if(alive1.get_ref() and alive2.get_ref()):
			if((alive1.get_ref().has_method("isEnemy")) and (alive2.get_ref().has_method("isEnemy"))): #if an enemy bullet hits another enemy, ignore it
				if(!alive2.get_ref().isEnemy()):#check if target is an ally with the player
					collision.collider.setHealth(collision.collider.getHealth() - 50)
					queue_free()
				queue_free()
			else:
				if(collision.collider == shooter):
					queue_free()
				else:
					get_node("Sprite").set_texture(explos_1)
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