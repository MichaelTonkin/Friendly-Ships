extends KinematicBody2D

var player
var fireDest
onready var laser = preload("res://Scenes/Bullets.tscn")

func _ready():
	player = get_node("/root/MainGame/Player")
	set_process(true) 

func _physics_process(delta):
	aim_and_move()
	open_fire(delta)

#function: aim_and_move
#description: handles the ship moving towards the player and aiming
func aim_and_move():
	self.look_at(player.get_player_position())

func open_fire(delta):
	fireDest = (player.position - self.position).normalized()
	
	var l = laser.instance()
	get_tree().get_root().add_child(l)
	l.set_position(self.position)
	
	l.set_direction(fireDest * 500 * delta)
	