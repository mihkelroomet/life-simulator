extends Node

signal start_activity(activity : Globals.Activity, activity_desired_duration : float, is_yellow_level_attempt : bool, activity_actual_duration : float)
signal fail_to_start_activity
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

func _on_start_activity(activity : Globals.Activity, activity_desired_duration : float, is_yellow_level_attempt : bool = false, activity_actual_duration : float = activity_desired_duration):
	start_activity.emit(activity, activity_desired_duration, is_yellow_level_attempt, activity_actual_duration)

func _on_fail_to_start_activity():
	fail_to_start_activity.emit()

func _on_stop_activity():
	stop_activity.emit()

func _on_set_game_speed(speed : float):
	set_game_speed.emit(speed)

func _on_set_time_is_advancing(if_is_advancing : bool):
	set_time_is_advancing.emit(if_is_advancing)

func _on_set_player_can_move(if_can_move : bool):
	set_player_can_move.emit(if_can_move)

func _on_need_satisfaction_changed(need : Globals.Need, new_value : float):
	need_satisfaction_changed.emit(need, new_value)

func _on_motivation_changed(new_value : float):
	motivation_changed.emit(new_value)

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
