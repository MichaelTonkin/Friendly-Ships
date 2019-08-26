extends KinematicBody2D

var player
var playerPos
var friendly = true # 20% chance of being friendly
var ally = false #only true if entity is turned into ally
var fireDest
var reloading = 0.0
var RELOAD_TIME = 1.0
onready var laser = preload("res://Scenes/Bullets.tscn")

func _ready():
	player = get_node("/root/MainGame/Player")
	set_process(true) 
	
	#check if this entity could be friendly
	var alignCheck = rand_range(0, 100)
	if(alignCheck <=20):
		friendly = true


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
		move_and_collide((playerPos) * player.get_speed() * delta)
		set_collision_layer_bit(3, true)
		set_collision_layer_bit(1, false)

func open_fire(delta):
	
	if (reloading <= 0.0 and ally == false):
		
		fireDest = playerPos
		var l = laser.instance()
		get_tree().get_root().add_child(l)
		l.set_shooters_name(self.name)
		l.set_position(self.position)
		l.set_direction(fireDest * 50)
		
		reloading = RELOAD_TIME
		#might as well use this space to check for player conversion attempts
		if(fireDest < Vector2(100, 100) and friendly == true):
			ally = true
			
	reloading -= delta