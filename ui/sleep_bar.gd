extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar

func set_sleep(sleep):
	progress_bar.value = clamp(sleep, 0, 100)
	
func _process(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	Globals.sleep -= game_hours_elapsed * Globals.SLEEP_LOSS
	Globals.sleep = clamp(Globals.sleep, 0, 100)
	set_sleep(Globals.sleep)
