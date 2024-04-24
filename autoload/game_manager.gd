extends Node

## How many times faster game time advances compared to real time.
const DEFAULT_GAME_SPEED : float = 150.0
var game_speed : float

var time_is_advancing : bool = true
var player_can_move : bool = true

var game_time : float = Time.get_unix_time_from_datetime_string("2024-09-02T08:00:00")

func _ready():
	Events.set_game_speed.connect(_on_set_game_speed)
	Events.set_time_is_advancing.connect(_on_set_time_is_advancing)
	Events.set_player_can_move.connect(_on_set_player_can_move)
	
	game_speed = DEFAULT_GAME_SPEED

func _on_set_game_speed(speed : float):
	game_speed = speed

func _on_set_time_is_advancing(is_advancing : bool):
	time_is_advancing = is_advancing

func _on_set_player_can_move(can_move : bool):
	player_can_move = can_move
