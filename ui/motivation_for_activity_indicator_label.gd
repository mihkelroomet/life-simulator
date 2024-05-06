extends Label

const VERY_LOW_LOW_THRESHOLD : float = 0.13
const LOW_MEDIUM_THRESHOLD : float = 0.33
const MEDIUM_HIGH_THRESHOLD : float = 0.67
const HIGH_VERY_HIGH_THRESHOLD : float = 0.87
const DUMMY_MAX_THRESHOLD : float = 10000.0

var thresholds : Array[float]
var labels : Array[String] = ["VERY LOW", "LOW", "MEDIUM", "HIGH", "VERY HIGH"]

var min_hue : float = 0
var max_hue : float = 0.33
var saturation : float = 0.4
var lightness_value : float = 0.8
var alpha: float = 1

func _ready():
	Events.motivation_changed.connect(_on_motivation_changed)
	
	thresholds = [VERY_LOW_LOW_THRESHOLD, LOW_MEDIUM_THRESHOLD, MEDIUM_HIGH_THRESHOLD, HIGH_VERY_HIGH_THRESHOLD, DUMMY_MAX_THRESHOLD]

func _on_motivation_changed(new_value : float):
	for i in range(thresholds.size()):
		if new_value <= thresholds[i]:
			text = labels[i]
			break
	
	var hue = min_hue + (max_hue - min_hue) * new_value
	self_modulate = Color.from_hsv(hue, saturation, lightness_value, alpha)
