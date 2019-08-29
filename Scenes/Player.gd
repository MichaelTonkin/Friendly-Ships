extends KinematicBody2D

const SPEED = 500
var health = 500
var mousePosition
var velocity
var globalMouse
var fireDest
var laser = preload("res://Scenes/Bullets.tscn")
var location = self.position

func _ready():
	set_process(true)
	
func _process(delta):
	if(health <= 0):
	# open the store
		get_tree().change_scene("res://Scenes/Menus/Store.tscn")
	
func _physics_process(delta):
	move_player(delta)
	fire_controller(delta)

#function: move_player
#description: controls the inputs for moving the player
func move_player(delta):
	
	#make the ship face the mouse
	mousePosition = get_local_mouse_position()
	rotation += mousePosition.angle()*0.1
	
	#make the player ship follow the mouse
	if(Input.is_action_pressed("move_up")):
		
		globalMouse = get_global_mouse_position()
		velocity = (globalMouse - position).normalized()
		move_and_collide(velocity * SPEED * delta)
		location = self.position
		#play animation
		$Player_tex.play("fly")

#function: fire_controller
#description: handles shooting
func fire_controller(delta):
	
	if(Input.is_action_just_pressed("player_fire")):
		
		
		globalMouse = get_global_mouse_position()
		fireDest = (globalMouse - position).normalized()
		
		$pew.play()
		
		var l = laser.instance()
		get_tree().get_root().add_child(l)
		l.add_collision_exception_with(self)
		l.set_shooters_name(self)
		l.set_position(self.position)
		
		l.set_direction(fireDest * 800 * delta)
	

func setHealth(var num):
	health = num
	
func getHealth():
	return health
	
func get_player_position():
	return self.position
	
func get_speed():
	return SPEED