extends Resource

const EffectData = preload("res://data/effect_data.gd")

@export var modifiers : Dictionary
@export var effects : Dictionary

var default_modifiers : Dictionary = {
	Globals.Need.AUTONOMY : Curve.new(),
	Globals.Need.COMPETENCE : Curve.new(),
	Globals.Need.RELATEDNESS : Curve.new(),
	Globals.Need.NUTRITION : Curve.new(),
	Globals.Need.PA : Curve.new(),
	Globals.Need.SLEEP : Curve.new()
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
