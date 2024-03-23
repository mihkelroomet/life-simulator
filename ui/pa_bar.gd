extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar
	
func _process(delta):
	calculate_pa(delta)

func calculate_pa(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	var pa_change = -(game_hours_elapsed * Globals.pa * Globals.PA_LOSS_FACTOR)
	var pa = Globals.pa + pa_change
	set_pa(pa)

func set_pa(pa):
	pa = clamp(pa, 0, 100)
	Globals.pa = pa
	progress_bar.value = pa
