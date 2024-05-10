extends Node2D

signal start_game
signal set_time_is_advancing(is_advancing : bool)
signal set_player_can_move(can_move : bool)

func _ready():
	start_game.connect(Events._on_start_game)
	set_time_is_advancing.connect(Events._on_set_time_is_advancing)
	set_player_can_move.connect(Events._on_set_player_can_move)
	
	start_game.emit()
	set_time_is_advancing.emit(true)
	set_player_can_move.emit(false)
