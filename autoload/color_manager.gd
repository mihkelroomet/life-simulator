extends Node

const RED_GREEN_GRADIENT : Dictionary = {
	"min_hue" : 0.0,
	"max_hue" : 0.33,
	"saturation" : 0.4,
	"lightness" : 0.8,
	"alpha" : 1.0
}

## Self-modulates the given node according to the given value. Colors are
## picked from a gradient from red to green. Input values should range from
## 0.0 (red) to 1.0 (green).
func self_modulate_red_green_gradient(target : Node, value : float):
	var hue = RED_GREEN_GRADIENT["min_hue"] + (RED_GREEN_GRADIENT["max_hue"] - RED_GREEN_GRADIENT["min_hue"]) * value
	target.self_modulate = Color.from_hsv(hue, RED_GREEN_GRADIENT["saturation"], RED_GREEN_GRADIENT["lightness"], RED_GREEN_GRADIENT["alpha"])
