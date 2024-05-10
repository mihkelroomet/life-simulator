extends VBoxContainer

signal set_activity_start_panel_selected_duration(duration : int)

const OngoingActivityPanel = preload("res://ui/ongoing_activity_panel.gd")

enum PressedKey {NONE, LEFT, RIGHT}

@onready var activity_duration_label = $ActivityDurationLabel
@onready var activity_duration_slider = $ActivityDurationSlider
@onready var estimated_completion_time_label = $EstimatedCompletionTimeLabel
@onready var hold_key_delay_timer = $HoldKeyDelayTimer
@onready var repeat_key_timer = $RepeatKeyTimer

var last_pressed_key : PressedKey = PressedKey.NONE

func _ready():
	set_activity_start_panel_selected_duration.connect(Events._on_set_activity_start_panel_selected_duration)
	Events.set_activity_start_panel_visible.connect(_on_set_activity_start_panel_visible)
	Events.set_activity_start_panel_selected_activity.connect(_on_set_activity_start_panel_selected_activity)

func _process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		activity_duration_slider.value -= 1
		last_pressed_key = PressedKey.LEFT
		repeat_key_timer.stop()
		hold_key_delay_timer.start()
	if Input.is_action_just_pressed("ui_right"):
		activity_duration_slider.value += 1
		last_pressed_key = PressedKey.RIGHT
		repeat_key_timer.stop()
		hold_key_delay_timer.start()
	
	if (
		last_pressed_key == PressedKey.LEFT and Input.is_action_just_released("ui_left") or
		last_pressed_key == PressedKey.RIGHT and Input.is_action_just_released("ui_right")
	):
		hold_key_delay_timer.stop()
		repeat_key_timer.stop()

func set_duration(quarters_of_hour : int):
	var full_hours : int = floor(quarters_of_hour / 4.0)
	var minutes : int = quarters_of_hour % 4 * 15
	
	var text : String = ""
	if full_hours != 0:
		text = str(full_hours) + "h "
	text += str(minutes) + "min"
	
	activity_duration_label.text = text
	
	set_activity_start_panel_selected_duration.emit(quarters_of_hour / 4.0)

func update_estimated_completion_time(selected_activity : ActivityManager.Activity):
	var completion_time = GameManager.game_time + activity_duration_slider.value * 15 * 60
	
	# Adjusting for yellow level if necessary. On yellow level it takes a little bit of
	# time to start the activity.
	var motivation_for_activity = ActivityManager.get_motivation_for_activity(selected_activity)
	if motivation_for_activity > 0.0 and motivation_for_activity < 1.0:
		completion_time += ActivityManager.activity_attempt_length * ActivityManager.activity_attempt_speed_multiplier * GameManager.DEFAULT_GAME_SPEED
	
	estimated_completion_time_label.text = "Estimated time of completion: " + TimeUtils.get_time_from_unix_time(completion_time)

func _on_set_activity_start_panel_visible(p_visible : bool, _activities : Array[ActivityManager.Activity]):
	if p_visible:
		activity_duration_slider.min_value = 0
		activity_duration_slider.max_value = 1
		activity_duration_slider.value = 0
		activity_duration_slider.editable = false
		activity_duration_label.text = "?h ?min"
		
		estimated_completion_time_label.text = ""

func _on_set_activity_start_panel_selected_activity(activity : ActivityManager.Activity):
	var activity_data = ActivityManager.get_activity_data(activity)
	
	var min_quarters_of_hour = round(activity_data.min_duration / 0.25)
	var max_quarters_of_hour = round(activity_data.max_duration / 0.25)
	var default_quarters_of_hour = round(activity_data.default_duration / 0.25)
	
	activity_duration_slider.min_value = min_quarters_of_hour
	activity_duration_slider.max_value = max_quarters_of_hour
	activity_duration_slider.value = default_quarters_of_hour
	
	# Disable slider if there is only one possible duration, enable it otherwise
	if min_quarters_of_hour == default_quarters_of_hour and default_quarters_of_hour == max_quarters_of_hour:
		activity_duration_slider.editable = false
	else:
		activity_duration_slider.editable = true
	
	set_duration(default_quarters_of_hour)

func _on_activity_duration_slider_value_changed(value):
	set_duration(value)

func _on_hold_key_delay_timer_timeout():
	repeat_key_timer.start()

func _on_repeat_key_timer_timeout():
	if last_pressed_key == PressedKey.LEFT:
		activity_duration_slider.value -= 1
	elif last_pressed_key == PressedKey.RIGHT:
		activity_duration_slider.value += 1
