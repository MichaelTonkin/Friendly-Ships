extends KinematicBody2D

var health = 100
var speed = 3000
var player
var playerPos
var friendly = false # 20% chance of being friendly
var ally = false #only true if entity is turned into ally
var fireDest
var reloading = 0.0
var RELOAD_TIME = 2.0
var attFormation
var distance2Player

onready var aFail = preload("res://Textures/ally_fail.png")
onready var aPass = preload("res://Textures/ally_success.png")
onready var laser = preload("res://Scenes/Bullets.tscn")
#onready var main = load("res://Scripts/MainGame.gd")
var main
var rand1
var rand2 
func _ready():
	player = get_node("/root/MainGame/Player") 
	main = get_node("/root/MainGame/")
	set_process(true) 
	rand1 = rand_range(rand_range(-600, -500), rand_range(500, 600))
	rand2 = rand_range(rand_range(-600, -500), rand_range(500, 600))
	#check if this entity could be friendly
	var alignCheck = rand_range(0, 100)
	if(alignCheck <=30):
		friendly = true

func _process(delta):
	
	attempt_align_shift()
	
	if(health <= 0):
		main.numShipsOnScreen -=1
		self.queue_free()

func _physics_process(delta):
	aim_and_move(delta)
	open_fire(delta)
	ally_score_contribute(delta)

#function: aim_and_move
#description: handles the ship moving towards the player and aiming
func aim_and_move(delta):
	playerPos = (player.position - self.position).normalized()*0.1
	self.look_at(player.get_player_position())
	
	#if the entity is an ally make it follow right behind the player
	if(ally == true):
		move_and_collide((playerPos) * (speed+1100) * delta)
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
		
		$pew.play()
		
		reloading = RELOAD_TIME
		
	reloading -= delta

#function:attempt_align_shift
#description: If a player hits spacebar and is close enough to a potentially friendly ship, that ship will turn into an ally
#This method hanldes ally transformation.
func attempt_align_shift():
	
	distance2Player = self.get_global_position().distance_to(player.get_position())
	
	if(Input.is_action_just_pressed("space_bar") and friendly and (distance2Player<10)):
		ally = true
		main.numShipsOnScreen -=1
		$Enemy_tex.stop()
		$Enemy_tex.play("ally")
	if(Input.is_action_just_pressed("space_bar") and !friendly):
		$Status_tex.set_texture(aFail)

func ally_score_contribute(delta):
	if(ally):
		if(reloading <= 0.0):
			Globals.score += 100
			reloading = RELOAD_TIME
		reloading -= delta
		
		#also using this space to make sure animation is working properly
		
		if($Enemy_tex.get_animation() == "default"):
			$Enemy_tex.play("ally")

func setHealth(var num):
	health = num
	
func getHealth():
	return health

func isEnemy():
	return !ally