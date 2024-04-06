extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar

var min_hue : float = 0
var max_hue : float = 0.33
var saturation : float = 0.4
var lightness_value : float = 0.8
var alpha: float = 1

func _ready():
	GameManager.motivation_changed.connect(_on_motivation_changed)

func _process(_delta):
	var value_percent = (progress_bar.value - progress_bar.min_value) / (progress_bar.max_value - progress_bar.min_value)
	var hue = min_hue + (max_hue - min_hue) * value_percent
	progress_bar.self_modulate = Color.from_hsv(hue, saturation, lightness_value, alpha)

func _on_motivation_changed(new_value):
	set_new_value(new_value)

## Adjusts for the bar's min and max values set in editor
func set_new_value(new_value):
	progress_bar.value = progress_bar.min_value + new_value * (progress_bar.max_value - progress_bar.min_value)
