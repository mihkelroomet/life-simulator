extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar
	
func _process(delta):
	calculate_sleep(delta)

func calculate_sleep(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	var sleep_change = -(game_hours_elapsed * Globals.sleep * Globals.SLEEP_LOSS_FACTOR)
	var sleep = Globals.sleep + sleep_change
	set_sleep(sleep)

func set_sleep(sleep):
	sleep = clamp(sleep, 0, 100)
	Globals.sleep = sleep
	progress_bar.value = sleep
