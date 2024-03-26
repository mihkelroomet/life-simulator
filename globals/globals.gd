extends Node

enum Activity {IDLE, MEET_FRIEND, PARTY, EAT_HEALTHY, EAT_JUNK, WALK, MODERATE_JOG, INTENSE_JOG, NAP, SLEEP}

enum Need {AUTONOMY, COMPETENCE, RELATEDNESS, NUTRITION, PA, SLEEP}

const CurveData = preload("res://data/curve_data.gd")
const EffectData = preload("res://data/effect_data.gd")
const ActivityData = preload("res://data/activity_data.gd")

const GAME_SPEED : int = 150 # How many times faster game time advances compared to real time

var game_is_running : bool = true

var game_time : float = Time.get_unix_time_from_datetime_string("2024-09-02T08:00:00")

# Current satisfaction of needs
var need_stats : Dictionary = {
	Need.AUTONOMY : 0.8,
	Need.COMPETENCE : 0.8,
	Need.RELATEDNESS : 0.8,
	Need.NUTRITION : 0.8,
	Need.PA : 0.8,
	Need.SLEEP : 0.8
}

var motivation : float = 0.8

var current_activity : Activity # This gets assigned the default value 0 aka IDLE at start

var activity_data : Dictionary = {
	Activity.IDLE : ActivityData.new({Need.COMPETENCE : CurveData.new([Vector2(0.2, 0.2)])}),
	Activity.MEET_FRIEND : ActivityData.new(),
	Activity.PARTY : ActivityData.new(),
	Activity.EAT_HEALTHY : ActivityData.new(),
	Activity.EAT_JUNK : ActivityData.new(),
	Activity.WALK : ActivityData.new(),
	Activity.MODERATE_JOG : ActivityData.new(),
	Activity.INTENSE_JOG : ActivityData.new(),
	Activity.NAP : ActivityData.new(),
	Activity.SLEEP : ActivityData.new()
}

func _ready():
	GameManager.motivation_changed.connect(_on_motivation_changed)
	GameManager.need_satisfaction_changed.connect(_on_need_satisfaction_changed)

func get_current_activity_data() -> ActivityData:
	return activity_data[current_activity]

func _on_need_satisfaction_changed(need, new_value):
	need_stats[need] = new_value

func _on_motivation_changed(new_value):
	motivation = new_value
