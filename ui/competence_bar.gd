extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar

func set_competence(competence):
	progress_bar.value = clamp(competence, 0, 100)
	
func _process(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	var center_value = (progress_bar.min_value + progress_bar.max_value) / 2
	var diff_from_center = Globals.competence - center_value
	Globals.competence -= game_hours_elapsed * diff_from_center * Globals.COMPETENCE_CENTER_FACTOR
	Globals.competence = clamp(Globals.competence, 0, 100)
	set_competence(Globals.competence)
