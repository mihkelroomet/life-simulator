extends Resource

# PERCENTAGE means per hour change by a percentage
# CENTER_PERCENTAGE means moving towards the middle value by percentage of gap to middle
enum EffectType {DECREASE_PERCENTAGE, DECREASE_LINEAR, INCREASE_LINEAR, CENTER_PERCENTAGE}

@export var effect_type : EffectType
@export var value : float

func _init(p_effect_type : EffectType = EffectType.DECREASE_PERCENTAGE, p_value : float = 0.1):
	effect_type = p_effect_type
	value = p_value
