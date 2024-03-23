extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar

func set_pa(pa):
	progress_bar.value = clamp(pa, 0, 100)
	
func _process(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	Globals.pa -= game_hours_elapsed * Globals.PA_LOSS
	Globals.pa = clamp(Globals.pa, 0, 100)
	set_pa(Globals.pa)
