extends VBoxContainer

@onready var motivation_progress_bar : ProgressBar = $MotivationBar/MarginContainer/VBoxContainer/ProgressBar
@onready var expanding_bars = $ExpandingBars

func set_motivation(motivation):
	motivation_progress_bar.value = clamp(motivation, 0, 100)
	
func _process(delta):
	var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
	Globals.motivation -= game_hours_elapsed * Globals.MOTIVATION_LOSS
	Globals.motivation = clamp(Globals.motivation, 0, 100)
	set_motivation(Globals.motivation)

func _on_motivation_bar_toggled(toggled_on):
	expanding_bars.visible = toggled_on
