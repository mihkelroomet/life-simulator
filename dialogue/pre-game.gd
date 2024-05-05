extends Node2D

func _ready():
	start_pre_game_dialogue()
	Dialogic.timeline_ended.connect(transition_to_in_game)

func start_pre_game_dialogue():
	Dialogic.start("pre-game")

func transition_to_in_game():
	get_tree().change_scene_to_file("res://world/in-game.tscn")
