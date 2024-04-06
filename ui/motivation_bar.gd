extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar

var min_hue : float = 0
var max_hue : float = 0.33
var saturation : float = 0.4
var lightness_value : float = 0.8
var alpha: float = 1

func _ready():
	GameManager.start_activity.connect(_on_start_activity)
	GameManager.stop_activity.connect(_on_stop_activity)
	GameManager.motivation_changed.connect(_on_motivation_changed)
	GameManager.set_ongoing_activity_panel_visible.connect(_on_set_ongoing_activity_panel_visible)

func _process(_delta):
	var value_percent = (progress_bar.value - progress_bar.min_value) / (progress_bar.max_value - progress_bar.min_value)
	var hue = min_hue + (max_hue - min_hue) * value_percent
	progress_bar.self_modulate = Color.from_hsv(hue, saturation, lightness_value, alpha)

func _on_motivation_changed(new_value):
	set_new_value(new_value)

## Adjusts for the bar's min and max values set in editor
func set_new_value(new_value):
	progress_bar.value = progress_bar.min_value + new_value * (progress_bar.max_value - progress_bar.min_value)

func _on_set_ongoing_activity_panel_visible(if_visible : bool):
	toggled.emit(if_visible)

func _on_start_activity(_activity : Globals.Activity, _duration : float):
	disabled = true

func _on_stop_activity():
	disabled = false
