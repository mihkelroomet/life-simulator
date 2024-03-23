extends ProgressBar

var min_hue : float = 0
var max_hue : float = 0.33
var saturation : float = 0.6
var lightness_value : float = 0.8
var alpha: float = 1

func _process(delta):
	var value_percent = (value - min_value) / (max_value - min_value)
	var hue = min_hue + (max_hue - min_hue) * value_percent
	print(hue)
	self_modulate = Color.from_hsv(hue, saturation, lightness_value, alpha)
