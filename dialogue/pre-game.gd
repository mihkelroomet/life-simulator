extends Node2D

signal set_time_is_advancing(if_advancing : bool)
signal set_player_can_move(can_move : bool)

func _ready():
	set_time_is_advancing.connect(Events._on_set_time_is_advancing)
	set_player_can_move.connect(Events._on_set_player_can_move)
	
	Dialogic.timeline_ended.connect(transition_to_in_game)
	
	set_time_is_advancing.emit(false)
	set_player_can_move.emit(false)
	start_pre_game_dialogue()

func start_pre_game_dialogue():
	Dialogic.start("pre-game")

func transition_to_in_game():
	get_tree().change_scene_to_file("res://world/in-game.tscn")
