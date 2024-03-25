extends ProgressBar

@export var need : Globals.Need
## Whether this bar is a motivation bar rather than a need bar.
@export var is_motivation_bar : bool

var min_hue : float = 0
var max_hue : float = 0.33
var saturation : float = 0.6
var lightness_value : float = 0.8
var alpha: float = 1

func _ready():
	GameManager.motivation_changed.connect(_on_motivation_changed)
	GameManager.need_satisfaction_changed.connect(_on_need_satisfaction_changed)

func _process(_delta):
	var value_percent = (value - min_value) / (max_value - min_value)
	var hue = min_hue + (max_hue - min_hue) * value_percent
	self_modulate = Color.from_hsv(hue, saturation, lightness_value, alpha)

func _on_need_satisfaction_changed(need, new_value):
	if self.need == need:
		set_new_value(new_value)

func _on_motivation_changed(new_value):
	if is_motivation_bar:
		set_new_value(new_value)

## Adjusts for the bar's min and max values set in editor
func set_new_value(new_value):
	value = min_value + new_value * (max_value - min_value)
