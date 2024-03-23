extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar

func set_nutrition(nutrition):
	progress_bar.value = clamp(nutrition, 0, 100)
	
func _process(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	Globals.nutrition -= game_hours_elapsed * Globals.NUTRITION_LOSS
	Globals.nutrition = clamp(Globals.nutrition, 0, 100)
	set_nutrition(Globals.nutrition)
