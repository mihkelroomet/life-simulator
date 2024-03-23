extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar
	
func _process(delta):
	calculate_autonomy(delta)

func calculate_autonomy(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	var center_value = (progress_bar.min_value + progress_bar.max_value) / 2
	var diff_from_center = Globals.autonomy - center_value
	var autonomy_change = -(game_hours_elapsed * diff_from_center * Globals.AUTONOMY_CENTER_FACTOR)
	var autonomy = Globals.autonomy + autonomy_change
	set_autonomy(autonomy)

func set_autonomy(autonomy):
	autonomy = clamp(autonomy, 0, 100)
	Globals.autonomy = autonomy
	progress_bar.value = autonomy
