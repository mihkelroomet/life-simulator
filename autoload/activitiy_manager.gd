extends Node

const ActivityData = preload("res://data/activity_data.gd")
const Activities = preload("res://data/activities.gd")

enum Activity {
	IDLE,
	MEET_FRIEND, PARTY, WALK, MODERATE_JOG, INTENSE_JOG,
	EAT_HEALTHY, EAT_JUNK,
	NAP, SLEEP
	}

var current_activity : Activity # This gets assigned the default value 0 aka IDLE at start

## Controls duration of activity attempt at yellow level
var activity_attempt_length : float = 1.0
## Controls how much faster the game runs during a yellow level activity attempt compared to idling.
var activity_attempt_speed_multiplier : float = 5.0

func get_activity_data(activity : Activity) -> ActivityData:
	return Activities.activities[activity]

func get_current_activity_data() -> ActivityData:
	return get_activity_data(current_activity)

# Returns motivation in range [0.0, 1.0] for a given activity.
func get_motivation_for_activity(activity : Activity) -> float:
	var current_activity_modifiers = get_activity_data(activity).modifiers
	var motivation_for_activity = MotivationManager.motivation
	print("\n-----\nStarting activity: '", get_activity_data(activity).display_name, "'")
	
	for need in current_activity_modifiers:
		var curve_data = current_activity_modifiers[need]
		var motivation_modifier = curve_data.sample(NeedManager.need_stats[need])
		motivation_for_activity += motivation_modifier
		print("Contribution of need '", NeedManager.NEED_NAMES[need], "': ", motivation_modifier)
	
	print("Total motivation for activity '", get_activity_data(activity).display_name, "': ", motivation_for_activity, "\n")
	
	return clamp(motivation_for_activity, 0.0, 1.0)

func get_motivation_for_current_activity() -> float:
	return get_motivation_for_activity(current_activity)
