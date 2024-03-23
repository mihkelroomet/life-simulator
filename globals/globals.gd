extends Node

var GAME_SPEED : int = 150 # How many times faster game time advances compared to real time

# Center by this factor per hour of game time
# To center means to move closer to a half-filled bar
var AUTONOMY_CENTER_FACTOR : float = 0.3
var COMPETENCE_CENTER_FACTOR : float = 0.7

var RELATEDNESS_LOSS_FACTOR : float = 0.9 # Per hour of game time
var NUTRITION_LOSS_FACTOR : float = 0.7
var PA_LOSS_FACTOR : float = 0.5
var SLEEP_LOSS_FACTOR : float = 0.3

var game_time : int = Time.get_unix_time_from_datetime_string("2024-09-02T08:00:00")

var motivation : float = 80

var autonomy : float = 80
var competence : float = 80
var relatedness : float = 80
var nutrition : float = 80
var pa : float = 80
var sleep : float = 80
