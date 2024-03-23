extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar

func set_relatedness(relatedness):
	progress_bar.value = clamp(relatedness, 0, 100)
	
func _process(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	Globals.relatedness -= game_hours_elapsed * Globals.RELATEDNESS_LOSS
	Globals.relatedness = clamp(Globals.relatedness, 0, 100)
	set_relatedness(Globals.relatedness)
