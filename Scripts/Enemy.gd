extends KinematicBody2D

var health = 100
var speed = 3000
var player
var playerPos
var friendly = false # 20% chance of being friendly
var ally = false #only true if entity is turned into ally
var fireDest
var reloading = 0.0
var RELOAD_TIME = 1.0
var attFormation
onready var laser = preload("res://Scenes/Bullets.tscn")
#onready var main = load("res://Scripts/MainGame.gd")
var main
var rand1
var rand2 
func _ready():
	player = get_node("/root/MainGame/Player") 
	main = get_node("/root/MainGame/")
	set_process(true) 
	rand1 = rand_range(rand_range(-400, -200), rand_range(200, 400))
	rand2 = rand_range(rand_range(-400, -200), rand_range(200, 400))
	#check if this entity could be friendly
	var alignCheck = rand_range(0, 100)
	if(alignCheck <=20):
		friendly = true

func _process(delta):
	
	if(health <= 0):
		main.score += 100
		main.numShipsOnScreen -=1
		self.queue_free()

func _physics_process(delta):
	aim_and_move(delta)
	open_fire(delta)

#function: aim_and_move
#description: handles the ship moving towards the player and aiming
func aim_and_move(delta):
	playerPos = (player.position - self.position).normalized()*0.1
	self.look_at(player.get_player_position())
	
	#if the entity is an ally make it follow right behind the player
	if(ally == true):
		move_and_collide((playerPos) * speed * delta)
		set_collision_layer_bit(3, true)
		set_collision_layer_bit(1, false)
	else:
		attFormation = (((player.location - Vector2(rand1, rand2)) - self.position).normalized()*0.1)
		move_and_collide((attFormation) * (speed+1000) * delta)

func open_fire(delta):
	
	if (reloading <= 0.0 and ally == false):
		
		fireDest = playerPos
		var l = laser.instance()
		get_tree().get_root().add_child(l)
		l.add_collision_exception_with(self)
		l.set_shooters_name(self)
		l.set_position(self.position)
		l.set_direction((fireDest * (speed+3000)) * delta)
		
		reloading = RELOAD_TIME
		#might as well use this space to check for player conversion attempts
		if(fireDest < Vector2(100, 100) and friendly == true):
			ally = true
			
	reloading -= delta
	
func attempt_align_shift():
	if(Input.is_action_just_pressed("space_bar") and friendly):
			ally = true
			get_node("Enemy_tex").set_texture("Res://icon.png")

func setHealth(var num):
	health = num
	
func getHealth():
	return health

func isEnemy():
	return true