extends HBoxContainer

@onready var from_need_label = $FromNeedLabel
@onready var need_effect_label = $NeedEffectLabel

const VERY_NEG_NEG_THRESHOLD : float = -0.5
const NEG_NEU_THRESHOLD : float = -0.05
const NEU_POS_THRESHOLD : float = 0.05
const POS_VERY_POS_THRESHOLD : float = 0.5
const DUMMY_MAX_THRESHOLD : float = 10000.0

@export var need : NeedManager.Need

var thresholds : Array[float]
var effect_desc_array : Array[String] = ["VERY NEGATIVE", "NEGATIVE", "NEUTRAL", "POSITIVE", "VERY POSITIVE"]

func _ready():
	Events.update_need_effects.connect(_on_update_need_effects)
	
	thresholds = [VERY_NEG_NEG_THRESHOLD, NEG_NEU_THRESHOLD, NEU_POS_THRESHOLD, POS_VERY_POS_THRESHOLD, DUMMY_MAX_THRESHOLD]
	
	from_need_label.text = "From " + NeedManager.NEED_NAMES[need] + ": "

func _on_update_need_effects(motivation_for_activity_dict : Dictionary):
	var need_effect_amount = motivation_for_activity_dict[need]
	
	for i in range(thresholds.size()):
		if need_effect_amount <= thresholds[i]:
			need_effect_label.text = effect_desc_array[i]
			break
