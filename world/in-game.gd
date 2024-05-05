extends Node2D

signal set_time_is_advancing(if_advancing : bool)
signal set_player_can_move(can_move : bool)

func _ready():
	set_time_is_advancing.connect(Events._on_set_time_is_advancing)
	set_player_can_move.connect(Events._on_set_player_can_move)
	
	set_time_is_advancing.emit(true)
	set_player_can_move.emit(true)
