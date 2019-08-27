#Script: Main Game
#Description: Handles all generic actions that the game takes

extends Node2D

onready var ship = load("res://Scenes/Enemy.tscn")
var score = 0
var numShipsOnScreen = 0 #the number of ships currently in the game
var randomLoc

func _ready():
	set_process(true)
	
func _process(delta):
	spawn_ships()

	
#function:spawn_ships
#description: handles the spawning and rules of spawning all ships in the game
func spawn_ships():
	
	#if score is < 500 spawn 5 ships
	if((numShipsOnScreen < 5)):
		var s = ship.instance()
		add_child(s)
		randomLoc = get_node("Player").get_position() + Vector2(int(rand_range(-500, 500)), int(rand_range(-500, 500)))
		s.set_position(randomLoc)
		numShipsOnScreen += 1
		
#static func set_score(var num):
#	score += num
#	print(score)
#
#func get_score():
#	return score
#
#static func setShips(var num):
#	numShipsOnScreen += num
#	print(numShipsOnScreen)
