extends Control

onready var main = load("res://Scripts/MainGame.gd")

func _ready():
	
	print(main.score)
	#get_node("Score_actual").set_text(str(main.score))

