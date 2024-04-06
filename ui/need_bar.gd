extends Button

@onready var progress_bar = $MarginContainer/VBoxContainer/ProgressBar
@onready var label = $MarginContainer/VBoxContainer/Label

@export var need : Globals.Need

var min_hue : float = 0
var max_hue : float = 0.33
var saturation : float = 0.4
var lightness_value : float = 0.8
var alpha: float = 1

func _ready():
	Events.need_satisfaction_changed.connect(_on_need_satisfaction_changed)
	label.text = Globals.NEED_NAMES[need]

func _process(_delta):
	var value_percent = (progress_bar.value - progress_bar.min_value) / (progress_bar.max_value - progress_bar.min_value)
	var hue = min_hue + (max_hue - min_hue) * value_percent
	progress_bar.self_modulate = Color.from_hsv(hue, saturation, lightness_value, alpha)

func _on_need_satisfaction_changed(changed_need, new_value):
	if need == changed_need:
		set_new_value(new_value)

## Adjusts for the bar's min and max values set in editor
func set_new_value(new_value):
	progress_bar.value = progress_bar.min_value + new_value * (progress_bar.max_value - progress_bar.min_value)
