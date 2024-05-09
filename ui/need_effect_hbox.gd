extends HBoxContainer

const EffectData = preload("res://data/effect_data.gd")
const ActivityData = preload("res://data/activity_data.gd")
const ActivitySelectPanel = preload("res://ui/activity_select_panel.gd")

@onready var need_abbr_label = $NeedAbbrLabel
@onready var effect_label = $EffectLabel

const NEG_4_NEG_5_THRESHOLD : float = -0.69
const NEG_3_NEG_4_THRESHOLD : float = -0.49
const NEG_2_NEG_3_THRESHOLD : float = -0.29
const NEG_1_NEG_2_THRESHOLD : float = -0.09
const NEU_NEG_1_THRESHOLD : float = -0.01
const POS_1_NEU_THRESHOLD : float = 0.01
const POS_2_POS_1_THRESHOLD : float = 0.09
const POS_3_POS_2_THRESHOLD : float = 0.29
const POS_4_POS_3_THRESHOLD : float = 0.49
const POS_5_POS_4_THRESHOLD : float = 0.69
const DUMMY_MAX_THRESHOLD : float = 10000.0

@export var need : NeedManager.Need

var thresholds : Array[float]
var effect_desc_array : Array[String] = [
	"–––––", "––––", "–––", "––", "–", "N/A", "+", "++", "+++", "++++", "+++++"
	]

func _ready():
	Events.set_activity_start_panel_selected_activity.connect(_on_set_activity_start_panel_selected_activity)
	Events.set_activity_start_panel_selected_duration.connect(_on_set_activity_start_panel_selected_duration)
	
	thresholds = [
		NEG_4_NEG_5_THRESHOLD, NEG_3_NEG_4_THRESHOLD, NEG_2_NEG_3_THRESHOLD,
		NEG_1_NEG_2_THRESHOLD, NEU_NEG_1_THRESHOLD, POS_1_NEU_THRESHOLD,
		POS_2_POS_1_THRESHOLD, POS_3_POS_2_THRESHOLD, POS_4_POS_3_THRESHOLD,
		POS_5_POS_4_THRESHOLD, DUMMY_MAX_THRESHOLD]
	
	need_abbr_label.text = NeedManager.NEED_NAMES_ABBR[need]

func update_need_effect(activity : ActivityManager.Activity, duration : float):
	var activity_data : ActivityData = ActivityManager.get_activity_data(activity)
	var activity_effects = activity_data.effects
	var effect_on_need : EffectData = activity_effects[need]
	var effect_type = effect_on_need.effect_type
	var effect_value = effect_on_need.value
	if effect_type == EffectData.EffectType.DECREASE_PERCENTAGE or effect_type == EffectData.EffectType.DECREASE_LINEAR:
		effect_value *= -1.0
	
	# Adjusting for duration
	effect_value *= duration
	
	for i in range(thresholds.size()):
		if effect_value <= thresholds[i]:
			effect_label.text = effect_desc_array[i]
			break
	
	# Converting the need effect amount to the range [0.0, 1.0]
	var value_percent = clamp(effect_value, -0.5, 0.5) + 0.5
	ColorManager.self_modulate_red_green_gradient(effect_label, value_percent)

func _on_set_activity_start_panel_selected_activity(activity : ActivityManager.Activity):
	var default_duration = ActivityManager.get_activity_data(activity).default_duration
	update_need_effect(activity, default_duration)

func _on_set_activity_start_panel_selected_duration(duration : float):
	var selected_activity = ActivitySelectPanel.selected_activity
	update_need_effect(selected_activity, duration)
