extends Node

signal motivation_changed(new_value : float)

var motivation : float

## Represents min satisfaction needed in most neglected need for 100% motivation.
## Motivation is linearly mapped to satisfaction of most neglected need.
var min_satisfaction_threshold_for_full_motivation : float = 0.72
## Represents the highest min satisfaction in most neglected need that will convert to 0% motivation.
var min_satisfaction_threshold_for_no_motivation : float = 0.12

func _ready():
	motivation_changed.connect(Events._on_motivation_changed)

func _process(_delta):
	if GameManager.time_is_advancing:
		update_motivation()

func update_motivation():
	var min_need_satisfaction = NeedManager.need_stats.values().min()
	var new_motivation = (min_need_satisfaction - min_satisfaction_threshold_for_no_motivation) / (min_satisfaction_threshold_for_full_motivation - min_satisfaction_threshold_for_no_motivation)
	motivation = clamp(new_motivation, 0.0, 1.0)
	motivation_changed.emit(motivation)
