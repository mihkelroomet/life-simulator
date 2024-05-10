extends Node

signal end_game

## How many times faster game time advances compared to real time.
var default_game_speed : float = 150.0

var game_speed : float

var time_is_advancing : bool
var player_can_move : bool

var game_time : float

var game_start_time : float = Time.get_unix_time_from_datetime_string("2024-05-06T10:00:00")
var game_end_time : float = Time.get_unix_time_from_datetime_string("2024-05-16T00:00:00")

func _ready():
	end_game.connect(Events._on_end_game)
	Events.start_game.connect(_on_start_game)
	Events.set_default_game_speed.connect(_on_set_default_game_speed)
	Events.set_game_speed.connect(_on_set_game_speed)
	Events.set_game_time.connect(_on_set_game_time)
	Events.set_time_is_advancing.connect(_on_set_time_is_advancing)
	Events.set_player_can_move.connect(_on_set_player_can_move)

func _on_start_game():
	game_speed = default_game_speed
	game_time = game_start_time

func _on_set_default_game_speed(speed : float):
	default_game_speed = speed

func _on_set_game_speed(speed : float):
	game_speed = speed

func _on_set_game_time(time : float):
	game_time = clamp(time, 0.0, game_end_time)
	if game_time >= game_end_time:
		end_game.emit()

func _on_set_time_is_advancing(is_advancing : bool):
	time_is_advancing = is_advancing

func _on_set_player_can_move(can_move : bool):
	player_can_move = can_move
