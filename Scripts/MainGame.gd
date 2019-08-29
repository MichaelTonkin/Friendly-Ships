#Script: Main Game
#Description: Handles all generic actions that the game takes

extends Node2D

onready var ship = load("res://Scenes/Enemy.tscn")
var numShipsOnScreen = 0 #the number of ships currently in the game
var randomLoc

func _ready():
	set_process(true)
	
func _process(delta):
	spawn_ships()
	get_node("ParallaxBackground/UI_score").set_text(str(Globals.score))

#function: ship_spawner
#Description: called when a new ship needs to be spawned.
#Warning/s: Do no confuse with 'spawn_ships()', which handles the spawning rules. This only handles the generation aspect.
func ship_spawner():
	var s = ship.instance()
	add_child(s)
	randomLoc = get_node("Player").get_position() + Vector2(int(rand_range(-500, 500)), int(rand_range(-500, 500)))
	s.set_position(randomLoc)
	numShipsOnScreen += 1

#function:spawn_ships
#description: handles the spawning and rules of spawning all ships in the game
func spawn_ships():
	
	#if score is < 500 spawn 5 ships
	if((numShipsOnScreen < 5)):
		ship_spawner()
	if( (Globals.score > 500) and (numShipsOnScreen < 7) ): ship_spawner()
	if( (Globals.score > 1000) and (numShipsOnScreen < 10) ): ship_spawner()
	if( (Globals.score > 2000) and (numShipsOnScreen < 13) ): ship_spawner()
	if( (Globals.score > 4000) and (numShipsOnScreen < 15) ): ship_spawner()



