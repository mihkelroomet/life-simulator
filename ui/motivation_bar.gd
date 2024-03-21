extends CenterContainer

@onready var motivation_progress_bar : TextureProgressBar = $MarginContainer/VBoxContainer/TextureProgressBar
@onready var timer : Timer = $MotivationChangeTimer

func set_motivation(motivation):
	print("setting motivation to: ", motivation)
	motivation_progress_bar.value = clamp(motivation, 0, 100)
	
func _process(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	Globals.motivation -= game_hours_elapsed * Globals.MOTIVATION_LOSS
	Globals.motivation = clamp(Globals.motivation, 0, 100)
	set_motivation(Globals.motivation)
