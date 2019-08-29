extends Control

#onready var main = load("res://Scripts/MainGame.gd")

func _ready():
	print(Globals.score)
	get_node("Score_actual").set_text(str(Globals.score))

