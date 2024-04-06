extends Node

signal need_satisfaction_changed(need : Globals.Need, new_value : float)
signal motivation_changed(new_value : float)

const EffectData = preload("res://data/effect_data.gd")

## Represents min satisfaction needed in most neglected need for 100% motivation.
## Motivation is linearly mapped to satisfaction of most neglected need.
var min_satisfaction_for_full_motivation : float = 0.75

func _ready():
	need_satisfaction_changed.connect(Events._on_need_satisfaction_changed)
	motivation_changed.connect(Events._on_motivation_changed)

func _process(delta):
	if Globals.time_is_advancing:
		var game_hours_elapsed = delta * Globals.game_speed / 3600
		update_stats(game_hours_elapsed)

func update_stats(game_hours_elapsed):
	update_needs(game_hours_elapsed)
	update_motivation()

func update_needs(game_hours_elapsed):
	for need in Globals.Need.values():
		update_need(need, game_hours_elapsed)

func update_need(need, game_hours_elapsed):
	# The effect the current activity has on the need
	var effect_data : EffectData = Globals.get_current_activity_data().effects[need]
	var current_need_satisfaction = Globals.need_stats[need]
	
	# The value the need change calculation is based on
	var base_amount_to_calc_change : float
	match effect_data.effect_type:
		EffectData.EffectType.DECREASE_PERCENTAGE:
			base_amount_to_calc_change = -current_need_satisfaction
		EffectData.EffectType.DECREASE_LINEAR:
			base_amount_to_calc_change = -1.0
		EffectData.EffectType.INCREASE_LINEAR:
			base_amount_to_calc_change = 1.0
		EffectData.EffectType.CENTER_PERCENTAGE:
			base_amount_to_calc_change = 0.5 - current_need_satisfaction
	
	var need_change = game_hours_elapsed * base_amount_to_calc_change * effect_data.value
	var new_need_satisfaction = current_need_satisfaction + need_change
	new_need_satisfaction = clamp(new_need_satisfaction, 0.0, 1.0)
	need_satisfaction_changed.emit(need, new_need_satisfaction)

func update_motivation():
	var min_need_satisfaction = Globals.need_stats.values().min()
	var motivation = min_need_satisfaction / min_satisfaction_for_full_motivation
	motivation = clamp(motivation, 0.0, 1.0)
	motivation_changed.emit(motivation)
