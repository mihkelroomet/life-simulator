extends Button

@onready var progress_bar : ProgressBar = $MarginContainer/VBoxContainer/ProgressBarHBox/ProgressBar

var min_hue : float = 0
var max_hue : float = 0.33
var saturation : float = 0.4
var lightness_value : float = 0.8
var alpha: float = 1

## Percentage of bar that is filled at 0% motivation. This is because for the player to
## understand the bar is empty it is more intuitive to have a bit of the filling showing.
var empty_value_percentage : float = 0.02
## Bar value at 0% motivation. Gets set at runtime.
var empty_value : float

func _ready():
	Events.start_activity.connect(_on_start_activity)
	Events.stop_activity.connect(_on_stop_activity)
	Events.motivation_changed.connect(_on_motivation_changed)
	Events.set_ongoing_activity_panel_visible.connect(_on_set_ongoing_activity_panel_visible)
	
	empty_value = progress_bar.min_value + empty_value_percentage * (progress_bar.max_value - progress_bar.min_value)

func _process(_delta):
	var value_percent = (progress_bar.value - progress_bar.min_value) / (progress_bar.max_value - progress_bar.min_value)
	var hue = min_hue + (max_hue - min_hue) * value_percent
	progress_bar.self_modulate = Color.from_hsv(hue, saturation, lightness_value, alpha)

func _on_motivation_changed(new_value):
	set_new_value(new_value)

## Adjusts for the bar's min and max values
func set_new_value(new_value):
	progress_bar.value = empty_value + new_value * (progress_bar.max_value - empty_value)

func _on_set_ongoing_activity_panel_visible(if_visible : bool):
	toggled.emit(if_visible)

func _on_start_activity(_activity : Globals.Activity, _activity_desired_duration : float, _is_yellow_level_attempt : bool, _activity_actual_duration : float):
	disabled = true

func _on_stop_activity():
	disabled = false
