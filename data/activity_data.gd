extends Resource

const CurveData = preload("res://data/curve_data.gd")
const EffectData = preload("res://data/effect_data.gd")

@export var display_name : String
## Used for displaying current action being undertaken, eg "Doing"
@export var present_participle : String
## Determines how current need satisfaction intervals influence being able to start the activity.
@export var modifiers : Dictionary
## Determines what effects this activity has on satisfaction of needs.
@export var effects : Dictionary
@export var min_duration : float
@export var default_duration : float
@export var max_duration : float

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
	Globals.Need.AUTONOMY : EffectData.new(EffectData.EffectType.CENTER_PERCENTAGE, 0.01),
	Globals.Need.COMPETENCE : EffectData.new(EffectData.EffectType.CENTER_PERCENTAGE, 0.01),
	Globals.Need.RELATEDNESS : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.01),
	Globals.Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.15),
	Globals.Need.PA : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.025),
	Globals.Need.SLEEP : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.1)
}

func _init(
	p_display_name = "Idle",
	p_present_participle = "Idling",
	p_modifiers = {},
	p_effects = {},
	p_min_duration = 0.0,
	p_default_duration = 0.0,
	p_max_duration = 0.0
	):
	display_name = p_display_name
	present_participle = p_present_participle
	
	# No need for deep copies as inner objects never change their states
	modifiers = default_modifiers.duplicate()
	modifiers.merge(p_modifiers, true)
	effects = default_effects.duplicate()
	effects.merge(p_effects, true)
	
	min_duration = p_min_duration
	default_duration = p_default_duration
	max_duration = p_max_duration
