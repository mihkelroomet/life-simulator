extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar
	
func _process(delta):
	calculate_relatedness(delta)

func calculate_relatedness(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	var relatedness_change = -(game_hours_elapsed * Globals.relatedness * Globals.RELATEDNESS_LOSS_FACTOR)
	var relatedness = Globals.relatedness + relatedness_change
	set_relatedness(relatedness)

func set_relatedness(relatedness):
	relatedness = clamp(relatedness, 0, 100)
	Globals.relatedness = relatedness
	progress_bar.value = relatedness
