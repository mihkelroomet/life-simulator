extends Button

signal start_activity(activity : Globals.Activity, activity_duration : float)
signal fail_to_start_activity

const CurveData = preload("res://data/curve_data.gd")
const ActivityStartPanel = preload("res://ui/activity_start_panel.gd")

var yellow_level_curve : CurveData = CurveData.new([Vector2(0.4, 0.0), Vector2(0.6, 1.0)])

func _ready():
	start_activity.connect(Events._on_start_activity)
	fail_to_start_activity.connect(Events._on_fail_to_start_activity)

func _on_button_pressed():
	var selected_activity = ActivityStartPanel.selected_activity
	var selected_duration = ActivityStartPanel.selected_duration
	
	if selected_activity != Globals.Activity.IDLE and selected_duration > 0.0:
		var motivation_for_selected_activity = Globals.get_motivation_for_activity(selected_activity)
		
		# Green level: can always do activity
		if motivation_for_selected_activity >= 1.0:
			start_activity.emit(selected_activity, selected_duration)
		
		# Red level: can never do activity
		elif motivation_for_selected_activity <= 0.0:
			fail_to_start_activity.emit()
		
		# Yellow level: might be able to do activity
		else:
			# On the yellow level the outcome is randomly chosen from the yellow level curve.
			# More specifically, the part on the curve 0.2 to either side of a starting point.
			# The starting point ranges from 0.2 at motivation 0 to 0.8 at motivation 1.
			var starting_point = motivation_for_selected_activity * 0.6 + 0.2
			var rng = RandomNumberGenerator.new()
			var chosen_point = rng.randf_range(starting_point - 0.2, starting_point + 0.2)
			
			# The outcome ranges 0 to 1. 0 means failed, 0.5 means half duration, 1 means full duration.
			var outcome = yellow_level_curve.sample(chosen_point)
			var actual_duration = selected_duration * outcome
			
			# If the activity is performed, it will take at least its min duration.
			var selected_activity_min_duration = Globals.get_activity_data(selected_activity).min_duration
			if actual_duration > 0.0 and actual_duration < selected_activity_min_duration:
				actual_duration = selected_activity_min_duration
			
			print("yellow: ", actual_duration)