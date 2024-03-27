extends Node

signal need_satisfaction_changed(need : Globals.Need, new_value : float)
signal motivation_changed(new_value : float)
signal activity_start_panel_visible_set(if_visible : bool, activities : Array[Globals.Activity])
signal game_is_running_set(if_running : bool)

const EffectData = preload("res://data/effect_data.gd")

func _process(delta):
	if Globals.game_is_running:
		var game_hours_elapsed = delta * Globals.GAME_SPEED / 3600
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
	
	# Temp for testing
	#var modifier : Curve = Globals.get_current_activity_data().modifiers[need].curve
	#print("Need: ", need)
	#print("Curve at 0: ", modifier.sample(0))
	#print("Curve at 0.5: ", modifier.sample(0.5))
	#print("Curve at 1: ", modifier.sample(1))

func update_motivation():
	var new_value = Globals.need_stats.values().min()
	new_value = clamp(new_value, 0.0, 1.0)
	motivation_changed.emit(new_value)

func _on_game_is_running_set(if_running : bool):
	game_is_running_set.emit(if_running)

func _on_activity_start_panel_visible_set(if_visible : bool, activities : Array[Globals.Activity]):
	activity_start_panel_visible_set.emit(if_visible, activities)
