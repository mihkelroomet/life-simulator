extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar
	
func _process(delta):
	calculate_nutrition(delta)

func calculate_nutrition(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	var nutrition_change = -(game_hours_elapsed * Globals.nutrition * Globals.NUTRITION_LOSS_FACTOR)
	var nutrition = Globals.nutrition + nutrition_change
	set_nutrition(nutrition)

func set_nutrition(nutrition):
	nutrition = clamp(nutrition, 0, 100)
	Globals.nutrition = nutrition
	progress_bar.value = nutrition
