extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar
	
func _process(delta):
	calculate_competence(delta)

func calculate_competence(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	var center_value = (progress_bar.min_value + progress_bar.max_value) / 2
	var diff_from_center = Globals.competence - center_value
	var competence_change = -(game_hours_elapsed * diff_from_center * Globals.COMPETENCE_CENTER_FACTOR)
	var competence = Globals.competence + competence_change
	set_competence(competence)

func set_competence(competence):
	competence = clamp(competence, 0, 100)
	Globals.competence = competence
	progress_bar.value = competence
