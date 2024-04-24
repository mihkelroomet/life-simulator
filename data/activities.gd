extends Node

const CurveData = preload("res://data/curve_data.gd")
const EffectData = preload("res://data/effect_data.gd")
const ActivityData = preload("res://data/activity_data.gd")

static var activities : Dictionary = {
	ActivityManager.Activity.IDLE : ActivityData.new(),
	ActivityManager.Activity.MEET_FRIEND : ActivityData.new(
		"Meet a Friend",
		"Meeting a Friend",
		{
			NeedManager.Need.RELATEDNESS : CurveData.new([Vector2(0.0, 0.5), Vector2(1.0, -0.2)])
		},
		{
			NeedManager.Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.045),
			NeedManager.Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			NeedManager.Need.RELATEDNESS : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.1),
			NeedManager.Need.PA : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.01)
		},
		0.5, 3.0, 6.0
	),
	ActivityManager.Activity.PARTY : ActivityData.new(
		"Party",
		"Partying",
		{
			NeedManager.Need.AUTONOMY : CurveData.new([Vector2(0.0, 0.3), Vector2(0.5, 0.0)]),
			NeedManager.Need.COMPETENCE : CurveData.new([Vector2(0.0, 0.3), Vector2(0.5, 0.0)]),
			NeedManager.Need.RELATEDNESS : CurveData.new([Vector2(0.0, 0.3), Vector2(0.5, 0.0)])
		},
		{
			NeedManager.Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			NeedManager.Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			NeedManager.Need.RELATEDNESS : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			NeedManager.Need.PA : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.01)
		},
		0.5, 5.0, 10.0
	),
	ActivityManager.Activity.WALK : ActivityData.new(
		"Walk",
		"Walking",
		{
			NeedManager.Need.PA : CurveData.new([Vector2(0.0, 0.25), Vector2(0.5, 0.0), Vector2(0.8, 0.0), Vector2(1.0, -0.5)])
		},
		{
			NeedManager.Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.01),
			NeedManager.Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.01),
			NeedManager.Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.18),
			NeedManager.Need.PA : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.05)
		},
		0.25, 0.75, 6.0
	),
	ActivityManager.Activity.MODERATE_JOG : ActivityData.new(
		"Moderate Jog",
		"Jogging at a Reasonable Pace",
		{
			NeedManager.Need.PA : CurveData.new([Vector2(0.0, -0.7), Vector2(0.5, 0.0), Vector2(0.8, 0.0), Vector2(1.0, -0.7)])
		},
		{
			NeedManager.Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.02),
			NeedManager.Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.21),
			NeedManager.Need.PA : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.2)
		},
		0.25, 0.75, 5.0
	),
	ActivityManager.Activity.INTENSE_JOG : ActivityData.new(
		"Intense Jog",
		"Jogging at an Intense Pace",
		{
			NeedManager.Need.PA : CurveData.new([Vector2(0.0, -0.9), Vector2(0.5, 0.0), Vector2(0.8, 0.0), Vector2(1.0, -0.9)])
		},
		{
			NeedManager.Need.AUTONOMY : EffectData.new(EffectData.EffectType.DECREASE_LINEAR, 0.08),
			NeedManager.Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			NeedManager.Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.3),
			NeedManager.Need.PA : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.3)
		},
		0.25, 0.5, 4.0
	),
	ActivityManager.Activity.EAT_HEALTHY : ActivityData.new(
		"Eat Healthy",
		"Eating Healthy Food",
		{
			NeedManager.Need.AUTONOMY : CurveData.new([Vector2(0.0, 0.1), Vector2(0.5, 0.0)]),
			NeedManager.Need.COMPETENCE : CurveData.new([Vector2(0.0, 0.1), Vector2(0.5, 0.0)]),
			NeedManager.Need.RELATEDNESS : CurveData.new([Vector2(0.0, 0.1), Vector2(0.5, 0.0)]),
			NeedManager.Need.NUTRITION : CurveData.new([Vector2(0.5, 1.0), Vector2(0.6, 0.0), Vector2(0.8, -1.0)]),
			NeedManager.Need.PA : CurveData.new([Vector2(0, 0.1), Vector2(0.5, 0.0)]),
			NeedManager.Need.SLEEP : CurveData.new([Vector2(0, 0.2), Vector2(0.3, 0.0)])
		},
		{
			NeedManager.Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			NeedManager.Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			NeedManager.Need.NUTRITION : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 2.4)
		},
		0.25, 0.25, 0.25
	),
	ActivityManager.Activity.EAT_JUNK : ActivityData.new(
		"Eat Junk",
		"Eating Junk Food",
		{
			NeedManager.Need.AUTONOMY : CurveData.new([Vector2(0.0, 0.2), Vector2(0.5, 0.0)]),
			NeedManager.Need.COMPETENCE : CurveData.new([Vector2(0.0, 0.2), Vector2(0.5, 0.0)]),
			NeedManager.Need.RELATEDNESS : CurveData.new([Vector2(0.0, 0.2), Vector2(0.5, 0.0)]),
			NeedManager.Need.NUTRITION : CurveData.new([Vector2(0.5, 1.0), Vector2(0.6, 0.0), Vector2(1.0, -0.6)]),
			NeedManager.Need.PA : CurveData.new([Vector2(0, 0.2), Vector2(0.5, 0.0)]),
			NeedManager.Need.SLEEP : CurveData.new([Vector2(0, 0.4), Vector2(0.3, 0.0)])
		},
		{
			NeedManager.Need.AUTONOMY : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			NeedManager.Need.COMPETENCE : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.03),
			NeedManager.Need.NUTRITION : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 1.8),
			NeedManager.Need.PA : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.1),
			NeedManager.Need.SLEEP : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.3)
		},
		0.25, 0.25, 0.25
	),
	ActivityManager.Activity.NAP : ActivityData.new(
		"Nap",
		"Napping",
		{
			NeedManager.Need.AUTONOMY : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			NeedManager.Need.COMPETENCE : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			NeedManager.Need.RELATEDNESS : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			NeedManager.Need.NUTRITION : CurveData.new([Vector2(0.0, -2.0), Vector2(0.4, 0.0)]),
			NeedManager.Need.PA : CurveData.new([Vector2(0.0, -0.2), Vector2(0.5, 0.0)]),
			NeedManager.Need.SLEEP : CurveData.new([Vector2(0.3, 1.0), Vector2(0.7, -1.0)])
		},
		{
			NeedManager.Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.09),
			NeedManager.Need.SLEEP : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.06)
		},
		0.5, 1.75, 6.25
	),
	ActivityManager.Activity.SLEEP : ActivityData.new(
		"Sleep",
		"Sleeping",
		{
			NeedManager.Need.AUTONOMY : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			NeedManager.Need.COMPETENCE : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			NeedManager.Need.RELATEDNESS : CurveData.new([Vector2(0.0, -0.1), Vector2(0.3, 0.0)]),
			NeedManager.Need.NUTRITION : CurveData.new([Vector2(0.0, -2.0), Vector2(0.4, 0.0)]),
			NeedManager.Need.PA : CurveData.new([Vector2(0.0, -0.2), Vector2(0.5, 0.0)]),
			NeedManager.Need.SLEEP : CurveData.new([Vector2(0.3, 1.0), Vector2(0.7, -1.0)])
		},
		{
			NeedManager.Need.NUTRITION : EffectData.new(EffectData.EffectType.DECREASE_PERCENTAGE, 0.09),
			NeedManager.Need.SLEEP : EffectData.new(EffectData.EffectType.INCREASE_LINEAR, 0.1)
		},
		7.75, 9.25, 18.25
	)
}