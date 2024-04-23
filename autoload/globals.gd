extends Node

enum Activity {
	IDLE,
	MEET_FRIEND, PARTY, WALK, MODERATE_JOG, INTENSE_JOG,
	EAT_HEALTHY, EAT_JUNK,
	NAP, SLEEP
	}

enum Need {AUTONOMY, COMPETENCE, RELATEDNESS, NUTRITION, PA, SLEEP}
const NEED_NAMES : Array = ["Autonomy", "Competence", "Relatedness", "Nutrition", "Physical Activity", "Sleep"]

const CurveData = preload("res://data/curve_data.gd")
const EffectData = preload("res://data/effect_data.gd")
const ActivityData = preload("res://data/activity_data.gd")

## How many times faster game time advances compared to real time.
const DEFAULT_GAME_SPEED : float = 150.0
var game_speed : float

var time_is_advancing : bool = true
var player_can_move : bool = true

var game_time : float = Time.get_unix_time_from_datetime_string("2024-09-02T08:00:00")

## Current satisfaction of needs
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
		"Meet a Friend",
		"Meeting a Friend",
		{
			Need.RELATEDNESS : CurveData.new([Vector2(0.0, 0.5), Vector2(1.0, -0.2)])
		},
		{
			Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.045),
			Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.RELATEDNESS : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.1),
			Need.PA : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.01)
		},
		0.5, 3.0, 6.0
	),
	Activity.PARTY : ActivityData.new(
		"Party",
		"Partying",
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
		0.5, 5.0, 10.0
	),
	Activity.WALK : ActivityData.new(
		"Walk",
		"Walking",
		{
			Need.PA : CurveData.new([Vector2(0.0, 0.25), Vector2(0.5, 0.0), Vector2(0.8, 0.0), Vector2(1.0, -0.5)])
		},
		{
			Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.01),
			Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.01),
			Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.18),
			Need.PA : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.05)
		},
		0.25, 0.75, 6.0
	),
	Activity.MODERATE_JOG : ActivityData.new(
		"Moderate Jog",
		"Jogging at a Reasonable Pace",
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
		"Jogging at an Intense Pace",
		{
			Need.PA : CurveData.new([Vector2(0.0, -0.9), Vector2(0.5, 0.0), Vector2(0.8, 0.0), Vector2(1.0, -0.9)])
		},
		{
			Need.AUTONOMY : EffectData.new(EffectData.EffectType.DECREASE_LINEAR, 0.08),
			Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.3),
			Need.PA : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.3)
		},
		0.25, 0.5, 4.0
	),
	Activity.EAT_HEALTHY : ActivityData.new(
		"Eat Healthy",
		"Eating Healthy Food",
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
		"Eating Junk Food",
		{
			Need.AUTONOMY : CurveData.new([Vector2(0.0, 0.2), Vector2(0.5, 0.0)]),
			Need.COMPETENCE : CurveData.new([Vector2(0.0, 0.2), Vector2(0.5, 0.0)]),
			Need.RELATEDNESS : CurveData.new([Vector2(0.0, 0.2), Vector2(0.5, 0.0)]),
			Need.NUTRITION : CurveData.new([Vector2(0.5, 1.0), Vector2(0.6, 0.0), Vector2(1.0, -0.6)]),
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
		"Napping",
		{
			Need.AUTONOMY : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.COMPETENCE : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.RELATEDNESS : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.NUTRITION : CurveData.new([Vector2(0.0, -2.0), Vector2(0.4, 0.0)]),
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
		"Sleeping",
		{
			Need.AUTONOMY : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.COMPETENCE : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.RELATEDNESS : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			Need.NUTRITION : CurveData.new([Vector2(0.0, -2.0), Vector2(0.4, 0.0)]),
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
	Events.set_game_speed.connect(_on_set_game_speed)
	Events.set_time_is_advancing.connect(_on_set_time_is_advancing)
	Events.set_player_can_move.connect(_on_set_player_can_move)
	Events.motivation_changed.connect(_on_motivation_changed)
	Events.need_satisfaction_changed.connect(_on_need_satisfaction_changed)
	
	game_speed = DEFAULT_GAME_SPEED

func _on_set_game_speed(speed : float):
	game_speed = speed

func get_activity_data(activity : Activity) -> ActivityData:
	return activity_data[activity]

func get_current_activity_data() -> ActivityData:
	return get_activity_data(current_activity)

# Returns motivation in range [0.0, 1.0] for a given activity.
func get_motivation_for_activity(activity : Activity) -> float:
	var current_activity_modifiers = get_activity_data(activity).modifiers
	var motivation_for_activity = motivation
	print("\n-----\nStarting activity: '", get_activity_data(activity).display_name, "'")
	
	for need in current_activity_modifiers:
		var curve_data : CurveData = current_activity_modifiers[need]
		var motivation_modifier = curve_data.sample(need_stats[need])
		motivation_for_activity += motivation_modifier
		print("Contribution of need '", NEED_NAMES[need], "': ", motivation_modifier)
	
	print("Total motivation for activity '", get_activity_data(activity).display_name, "': ", motivation_for_activity, "\n")
	
	return clamp(motivation_for_activity, 0.0, 1.0)

func get_motivation_for_current_activity() -> float:
	return get_motivation_for_activity(current_activity)

func _on_set_time_is_advancing(if_is_advancing : bool):
	time_is_advancing = if_is_advancing

func _on_set_player_can_move(if_can_move : bool):
	player_can_move = if_can_move

func _on_need_satisfaction_changed(need, new_value):
	need_stats[need] = new_value

func _on_motivation_changed(new_value):
	motivation = new_value
