extends Node

signal thesis_written_amount_changed(new_value : float)

## Part of thesis written per hour.
const THESIS_WRITING_SPEED : float = 0.0125 # Current value means 80h for whole thesis

const THESIS_WRITTEN_INITIAL_VALUE : float = 0.4

var grade_thresholds : Array[float] = [0.51, 0.61, 0.71, 0.81, 0.91, 10000.0]
var grades : Array[String] = ["F", "E", "D", "C", "B", "A"]

var thesis_written : float

func _ready():
	thesis_written_amount_changed.connect(Events._on_thesis_written_amount_changed)
	Events.start_game.connect(_on_start_game)

func _process(delta):
	if GameManager.time_is_advancing and ActivityManager.current_activity == ActivityManager.Activity.WRITE_THESIS:
		var game_hours_elapsed = delta * GameManager.game_speed / 3600
		write_thesis(game_hours_elapsed)

func write_thesis(game_hours_elapsed):
	thesis_written += game_hours_elapsed * THESIS_WRITING_SPEED
	thesis_written = clamp(thesis_written, 0.0, 1.0)
	thesis_written_amount_changed.emit(thesis_written)

func get_grade():
	for i in range(grade_thresholds.size()):
		if thesis_written < grade_thresholds[i]:
			return grades[i]

func _on_start_game():
	thesis_written = THESIS_WRITTEN_INITIAL_VALUE
	thesis_written_amount_changed.emit(thesis_written)
