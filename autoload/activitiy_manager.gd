extends Node

const ActivityData = preload("res://data/activity_data.gd")
const Activities = preload("res://data/activities.gd")

enum Activity {
	IDLE,
	MEET_FRIEND, PARTY, WALK, MODERATE_JOG, INTENSE_JOG,
	EAT_HEALTHY, EAT_JUNK,
	NAP, SLEEP,
	PROCRASTINATE, CHAT_ONLINE, PLAY_GAMES, WRITE_THESIS
	}

var current_activity : Activity # This gets assigned the default value 0 aka IDLE at start

## Controls duration of activity attempt at yellow level
var activity_attempt_length : float = 1.0
## Controls how much faster the game runs during a yellow level activity attempt compared to idling.
var activity_attempt_speed_multiplier : float = 5.0

func _ready():
	Events.start_game.connect(_on_start_game)

func get_activity_data(activity : Activity) -> ActivityData:
	return Activities.activities[activity]

func get_current_activity_data() -> ActivityData:
	return get_activity_data(current_activity)

## Returns motivation in range [0.0, 1.0] for a given activity.
func get_motivation_for_activity(activity : Activity) -> float:
	return _get_motivation_for_activity(activity, false, false)

## Returns motivation in range [0.0, 1.0] for a given activity and
## prints motivation breakdown details.
func get_and_print_motivation_for_activity(activity : Activity) -> float:
	return _get_motivation_for_activity(activity, true, false)

## Returns a dictionary, where the keys are need names and "Total".
## The value of "Total" is the total motivation for the given activity,
## in range [0.0, 1.0]. The other values each represent the contribution of the
## respective need.
func get_motivation_for_activity_dict(activity : Activity) -> Dictionary:
	return _get_motivation_for_activity(activity, false, true)

func get_motivation_for_current_activity() -> float:
	return get_motivation_for_activity(current_activity)

func get_need_effect_dict(activity : Activity):
	return _get_need_effect_dict(activity, false)

func _get_motivation_for_activity(activity : Activity, debug : bool, dict : bool):
	var motivation_for_activity = MotivationManager.motivation
	
	if debug:
		print("\n-----\nStarting activity: '", get_activity_data(activity).display_name, "'")
	
	var need_effect_dict = _get_need_effect_dict(activity, debug)
	motivation_for_activity += need_effect_dict["Total"]
	
	if debug:
		print("Total motivation for activity '", get_activity_data(activity).display_name, "': ", motivation_for_activity, "\n")
	
	motivation_for_activity = clamp(motivation_for_activity, 0.0, 1.0)
	
	if dict:
		need_effect_dict["Total"] = motivation_for_activity
		return need_effect_dict
	else:
		return motivation_for_activity

func _get_need_effect_dict(activity : Activity, debug : bool):
	var need_effect_dict : Dictionary = {}
	var total : float = 0.0
	
	var current_activity_modifiers = get_activity_data(activity).modifiers
	for need in current_activity_modifiers:
		var curve_data = current_activity_modifiers[need]
		var motivation_modifier = curve_data.sample(NeedManager.need_stats[need])
		need_effect_dict[need] = motivation_modifier
		total += motivation_modifier
		if debug:
			print("Contribution of need '", NeedManager.NEED_NAMES[need], "': ", motivation_modifier)
	
	need_effect_dict["Total"] = total
	
	return need_effect_dict

func _on_start_game():
	current_activity = Activity.IDLE
