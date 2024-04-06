extends Node

signal start_activity(activity : Globals.Activity, activity_duration : float)
signal stop_activity

signal set_time_is_advancing(if_is_advancing : bool)
signal set_game_speed(speed : float)
signal set_player_can_move(if_can_move : bool)

signal need_satisfaction_changed(need : Globals.Need, new_value : float)
signal motivation_changed(new_value : float)

signal set_activity_start_panel_visible(if_visible : bool, activities : Array[Globals.Activity])
signal set_activity_start_panel_selected_activity(activity : Globals.Activity)
signal set_activity_start_panel_selected_duration(duration : float)
signal set_ongoing_activity_panel_visible(if_visible : bool)

signal fade_out_color_rect

const EffectData = preload("res://data/effect_data.gd")

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

# Motivation is linearly tied to lowest need satisfaction at 75% satisfied = 100% motivation
func update_motivation():
	var min_need_satisfaction = Globals.need_stats.values().min()
	var motivation = min_need_satisfaction / 0.75
	motivation = clamp(motivation, 0.0, 1.0)
	motivation_changed.emit(motivation)

func _on_start_activity(activity : Globals.Activity, activity_duration : float):
	start_activity.emit(activity, activity_duration)

func _on_stop_activity():
	stop_activity.emit()

func _on_set_game_speed(speed : float):
	set_game_speed.emit(speed)

func _on_set_time_is_advancing(if_is_advancing : bool):
	set_time_is_advancing.emit(if_is_advancing)

func _on_set_player_can_move(if_can_move : bool):
	set_player_can_move.emit(if_can_move)

func _on_set_activity_start_panel_visible(if_visible : bool, activities : Array[Globals.Activity]):
	set_activity_start_panel_visible.emit(if_visible, activities)

func _on_set_activity_start_panel_selected_activity(activity : Globals.Activity):
	set_activity_start_panel_selected_activity.emit(activity)

func _on_set_activity_start_panel_selected_duration(duration : float):
	set_activity_start_panel_selected_duration.emit(duration)

func _on_set_ongoing_activity_panel_visible(if_visible : bool):
	set_ongoing_activity_panel_visible.emit(if_visible)
	
func _on_fade_out_color_rect():
	fade_out_color_rect.emit()
