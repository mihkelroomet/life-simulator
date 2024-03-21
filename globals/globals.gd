extends Node

var GAME_SPEED : int = 150 # How many times faster game time advances compared to real time
var MOTIVATION_LOSS : float = 100 # Motivation loss per hour of game time

var game_time : int = Time.get_unix_time_from_datetime_string("2024-09-02T08:00:00")
var motivation : float = 80
