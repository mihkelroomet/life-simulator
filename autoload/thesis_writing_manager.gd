extends Node

signal thesis_written_amount_changed(new_value : float)

var thesis_written : float = 0.2

func _ready():
	thesis_written_amount_changed.connect(Events._on_thesis_written_amount_changed)

func _process(delta):
	if GameManager.time_is_advancing and ActivityManager.current_activity == ActivityManager.Activity.WRITE_THESIS:
		var game_hours_elapsed = delta * GameManager.game_speed / 3600
		write_thesis(game_hours_elapsed)

func write_thesis(game_hours_elapsed):
	thesis_written += game_hours_elapsed / 100.0
	thesis_written_amount_changed.emit(thesis_written)
