extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar

func set_autonomy(autonomy):
	progress_bar.value = clamp(autonomy, 0, 100)
	
func _process(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	var center_value = (progress_bar.min_value + progress_bar.max_value) / 2
	var diff_from_center = Globals.autonomy - center_value
	Globals.autonomy -= game_hours_elapsed * diff_from_center * Globals.AUTONOMY_CENTER_FACTOR
	Globals.autonomy = clamp(Globals.autonomy, 0, 100)
	set_autonomy(Globals.autonomy)
