extends HBoxContainer

@onready var from_need_label = $FromNeedLabel
@onready var need_effect_label = $NeedEffectLabel

const VERY_NEG_NEG_THRESHOLD : float = -0.67
const NEG_SLI_NEG_THRESHOLD : float = -0.33
const SLI_NEG_NEU_THRESHOLD : float = -0.16
const NEU_SLI_POS_THRESHOLD : float = 0.16
const SLI_POS_POS_THRESHOL : float = 0.33
const POS_VERY_POS_THRESHOLD : float = 0.67
const DUMMY_MAX_THRESHOLD : float = 10000.0

@export var need : NeedManager.Need

var thresholds : Array[float]
var effect_desc_array : Array[String] = ["VERY NEGATIVE", "NEGATIVE", "SLIGHTLY NEGATIVE", "NEUTRAL", "SLIGHTLY POSITIVE", "POSITIVE", "VERY POSITIVE"]

func _ready():
	Events.update_need_effects.connect(_on_update_need_effects)
	
	thresholds = [VERY_NEG_NEG_THRESHOLD, NEG_SLI_NEG_THRESHOLD, SLI_NEG_NEU_THRESHOLD, NEU_SLI_POS_THRESHOLD, SLI_POS_POS_THRESHOL, POS_VERY_POS_THRESHOLD, DUMMY_MAX_THRESHOLD]
	
	from_need_label.text = "From " + NeedManager.NEED_NAMES[need] + ": "

func _on_update_need_effects(motivation_for_activity_dict : Dictionary):
	var need_effect_amount = motivation_for_activity_dict[need]
	
	for i in range(thresholds.size()):
		if need_effect_amount <= thresholds[i]:
			need_effect_label.text = effect_desc_array[i]
			break
	
	# Converting the need effect amount to the range [0.0, 1.0]
	var value_percent = (clamp(need_effect_amount, -1.0, 1.0) + 1.0) / 2.0
	ColorManager.self_modulate_red_green_gradient(need_effect_label, value_percent)
