extends Resource

const CurveData = preload("res://data/curve_data.gd")
const EffectData = preload("res://data/effect_data.gd")

## Determines how current need satisfaction intervals influence being able to start the activity.
@export var modifiers : Dictionary
## Determines what effects this activity has on satisfaction of needs.
@export var effects : Dictionary

# Each CurveData.curve is X = 0 by default
# Y values range from -1.0 to 1.0
# When overriding points can be added as an array of Vector2-s
var default_modifiers : Dictionary = {
	Globals.Need.AUTONOMY : CurveData.new(),
	Globals.Need.COMPETENCE : CurveData.new(),
	Globals.Need.RELATEDNESS : CurveData.new(),
	Globals.Need.NUTRITION : CurveData.new(),
	Globals.Need.PA : CurveData.new(),
	Globals.Need.SLEEP : CurveData.new()
}

var default_effects : Dictionary = {
	Globals.Need.AUTONOMY : EffectData.new(EffectData.EffectType.CENTER_PERCENTAGE),
	Globals.Need.COMPETENCE : EffectData.new(EffectData.EffectType.CENTER_PERCENTAGE),
	Globals.Need.RELATEDNESS : EffectData.new(),
	Globals.Need.NUTRITION : EffectData.new(),
	Globals.Need.PA : EffectData.new(),
	Globals.Need.SLEEP : EffectData.new()
}

func _init(p_modifiers = {}, p_effects = {}):
	# No need for deep copies as inner objects never change their states
	modifiers = default_modifiers.duplicate()
	modifiers.merge(p_modifiers, true)
	effects = default_effects.duplicate()
	effects.merge(p_effects, true)
