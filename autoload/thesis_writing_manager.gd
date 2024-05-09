extends Node

signal thesis_written_amount_changed(new_value : float)

## Part of thesis written per hour.
const THESIS_WRITING_SPEED : float = 0.0125 # Current value means 80h for whole thesis

var thesis_written : float = 0.4

func _ready():
	thesis_written_amount_changed.connect(Events._on_thesis_written_amount_changed)

func _process(delta):
	if GameManager.time_is_advancing and ActivityManager.current_activity == ActivityManager.Activity.WRITE_THESIS:
		var game_hours_elapsed = delta * GameManager.game_speed / 3600
		write_thesis(game_hours_elapsed)

func write_thesis(game_hours_elapsed):
	thesis_written += game_hours_elapsed * THESIS_WRITING_SPEED
	thesis_written_amount_changed.emit(thesis_written)
