extends Node

enum Activity {
	IDLE,
	MEET_FRIEND, PARTY, WALK, MODERATE_JOG, INTENSE_JOG,
	EAT_HEALTHY, EAT_JUNK,
	NAP, SLEEP
	}

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

var motivation : float

var current_activity : Activity # This gets assigned the default value 0 aka IDLE at start

var activity_data : Dictionary = {
	Activity.IDLE : ActivityData.new(),
	Activity.MEET_FRIEND : ActivityData.new(
		"Meet Friend",
		{
			Need.RELATEDNESS : CurveData.new([Vector2(0.0, 0.5), Vector2(1.0, -0.2)])
		},
		{
			Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.RELATEDNESS : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.1),
			Need.PA : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.01)
		},
		0.5, 3.0, 10.0
	),
	Activity.PARTY : ActivityData.new(
		"Party",
		{
			Need.AUTONOMY : CurveData.new([Vector2(0.0, 0.3), Vector2(0.5, 0.0)]),
			Need.COMPETENCE : CurveData.new([Vector2(0.0, 0.3), Vector2(0.5, 0.0)]),
			Need.RELATEDNESS : CurveData.new([Vector2(0.0, 0.3), Vector2(0.5, 0.0)])
		},
		{
			Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.RELATEDNESS : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.PA : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.01)
		},
		0.5, 5.0, 15.0
	),
	Activity.WALK : ActivityData.new(
		"Walk",
		{
			Need.PA : CurveData.new([Vector2(0.0, -0.5), Vector2(0.5, 0.0), Vector2(0.8, 0.0), Vector2(1.0, -0.5)])
		},
		{
			Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.01),
			Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.01),
			Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.18),
			Need.PA : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.05)
		},
		0.25, 0.75, 10.0
	),
	Activity.MODERATE_JOG : ActivityData.new(
		"Moderate Jog",
		{
			Need.PA : CurveData.new([Vector2(0.0, -0.7), Vector2(0.5, 0.0), Vector2(0.8, 0.0), Vector2(1.0, -0.7)])
		},
		{
			Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.02),
			Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.21),
			Need.PA : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.2)
		},
		0.25, 0.75, 5.0
	),
	Activity.INTENSE_JOG : ActivityData.new(
		"Intense Jog",
		{
			Need.PA : CurveData.new([Vector2(0.0, -0.9), Vector2(0.5, 0.0), Vector2(0.8, 0.0), Vector2(1.0, -0.9)])
		},
		{
			Need.AUTONOMY : EffectData.new(EffectData.EffectType.DECREASE_LINEAR, 0.1),
			Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.3),
			Need.PA : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.3)
		},
		0.25, 0.5, 4.0
	),
	Activity.EAT_HEALTHY : ActivityData.new(
		"Eat Healthy",
		{
			Need.AUTONOMY : CurveData.new([Vector2(0.0, 0.1), Vector2(0.5, 0.0)]),
			Need.COMPETENCE : CurveData.new([Vector2(0.0, 0.1), Vector2(0.5, 0.0)]),
			Need.RELATEDNESS : CurveData.new([Vector2(0.0, 0.1), Vector2(0.5, 0.0)]),
			Need.NUTRITION : CurveData.new([Vector2(0.5, 1.0), Vector2(0.6, 0.0), Vector2(0.8, -1.0)]),
			Need.PA : CurveData.new([Vector2(0, 0.1), Vector2(0.5, 0.0)]),
			Need.SLEEP : CurveData.new([Vector2(0, 0.2), Vector2(0.3, 0.0)])
		},
		{
			Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.NUTRITION : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 2.4)
		},
		0.25, 0.25, 0.25
	),
	Activity.EAT_JUNK : ActivityData.new(
		"Eat Junk",
		{
			Need.AUTONOMY : CurveData.new([Vector2(0.0, 0.2), Vector2(0.5, 0.0)]),
			Need.COMPETENCE : CurveData.new([Vector2(0.0, 0.2), Vector2(0.5, 0.0)]),
			Need.RELATEDNESS : CurveData.new([Vector2(0.0, 0.2), Vector2(0.5, 0.0)]),
			Need.NUTRITION : CurveData.new([Vector2(0.5, 1.0), Vector2(0.6, 0.0), Vector2(1.0, -1.0)]),
			Need.PA : CurveData.new([Vector2(0, 0.2), Vector2(0.5, 0.0)]),
			Need.SLEEP : CurveData.new([Vector2(0, 0.4), Vector2(0.3, 0.0)])
		},
		{
			Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.NUTRITION : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 1.8),
			Need.PA : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.1),
			Need.SLEEP : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.3)
		},
		0.25, 0.25, 0.25
	),
	Activity.NAP : ActivityData.new(
		"Nap",
		{
			Need.AUTONOMY : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.COMPETENCE : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.RELATEDNESS : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.NUTRITION : CurveData.new([Vector2(0.0, -1.0), Vector2(0.4, 0.0)]),
			Need.PA : CurveData.new([Vector2(0.0, -0.2), Vector2(0.5, 0.0)]),
			Need.SLEEP : CurveData.new([Vector2(0.3, 1.0), Vector2(0.7, -1.0)])
		},
		{
			Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.09),
			Need.SLEEP : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.06)
		},
		0.5, 1.75, 6.25
	),
	Activity.SLEEP : ActivityData.new(
		"Sleep",
		{
			Need.AUTONOMY : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.COMPETENCE : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.RELATEDNESS : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.NUTRITION : CurveData.new([Vector2(0.0, -1.0), Vector2(0.4, 0.0)]),
			Need.PA : CurveData.new([Vector2(0.0, -0.2), Vector2(0.5, 0.0)]),
			Need.SLEEP : CurveData.new([Vector2(0.3, 1.0), Vector2(0.7, -1.0)])
		},
		{
			Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.09),
			Need.SLEEP : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.1)
		},
		7.75, 9.25, 18.25
	)
}

func _ready():
	GameManager.set_game_is_running.connect(_on_set_game_is_running)
	GameManager.motivation_changed.connect(_on_motivation_changed)
	GameManager.need_satisfaction_changed.connect(_on_need_satisfaction_changed)

func get_current_activity_data() -> ActivityData:
	return activity_data[current_activity]

func get_activity_data(activity : Activity) -> ActivityData:
	return activity_data[activity]

func _on_set_game_is_running(if_running : bool):
	game_is_running = if_running

func _on_need_satisfaction_changed(need, new_value):
	need_stats[need] = new_value

func _on_motivation_changed(new_value):
	motivation = new_value
