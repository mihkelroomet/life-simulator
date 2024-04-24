extends Button

const CustomProgressBar = preload("res://ui/progress_bar.gd")

@onready var progress_bar : CustomProgressBar = $MarginContainer/VBoxContainer/ProgressBarHBox

func _ready():
	Events.start_activity.connect(_on_start_activity)
	Events.stop_activity.connect(_on_stop_activity)
	Events.motivation_changed.connect(_on_motivation_changed)
	Events.set_ongoing_activity_panel_visible.connect(_on_set_ongoing_activity_panel_visible)

func _on_motivation_changed(new_value):
	progress_bar.set_value(new_value)

func _on_set_ongoing_activity_panel_visible(p_visible : bool):
	toggled.emit(p_visible)

func _on_start_activity(_activity : ActivityManager.Activity, _activity_desired_duration : float, _is_yellow_level_attempt : bool, _activity_actual_duration : float):
	disabled = true

func _on_stop_activity():
	disabled = false
