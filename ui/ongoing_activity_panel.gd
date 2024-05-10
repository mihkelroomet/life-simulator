extends MarginContainer

signal set_game_speed(speed : float)
signal set_time_is_advancing(if_advancing : bool)
signal fade_out_color_rect
signal set_ongoing_activity_panel_visible(if_visible : bool)
signal end_game

@onready var ongoing_activity_label = $PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/OngoingActivityLabel
@onready var activity_end_label = $PanelContainer/MarginContainer/VBoxContainer2/ActivityEndLabel
@onready var animation_player = $AnimationPlayer

var current_activity : ActivityManager.Activity
## Duration of current activity in hours.
var current_activity_desired_duration : float
## If the current activity is only being attempted and isn't neccessarily going to be
## carried out fully.
var current_activity_is_yellow_level_attempt : bool
var current_activity_actual_duration : float
## Controls how much faster time advances during an attempt to start an activity compared to
## regular idling.

## Percentage of actual duration from desired duration
var duration_percentage : float
var present_participle : String

func _ready():
	set_game_speed.connect(Events._on_set_game_speed)
	set_time_is_advancing.connect(Events._on_set_time_is_advancing)
	fade_out_color_rect.connect(Events._on_fade_out_color_rect)
	set_ongoing_activity_panel_visible.connect(Events._on_set_ongoing_activity_panel_visible)
	end_game.connect(Events._on_end_game)
	Events.start_activity.connect(_on_start_activity)
	Events.set_ongoing_activity_panel_visible.connect(_on_set_ongoing_activity_panel_visible)
	
	animation_player.get_animation("attempt_activity").length = ActivityManager.activity_attempt_length

func play_do_activity_animation():
	var do_activity_animation : Animation = animation_player.get_animation("do_activity")
	do_activity_animation.track_set_key_value(0, 1, duration_percentage * 100)
	do_activity_animation.track_set_key_time(0, 1, duration_percentage)
	do_activity_animation.length = duration_percentage
	
	ongoing_activity_label.text = present_participle + "..."
	
	ActivityManager.current_activity = current_activity
	
	# This assumes the full "do_activity" animation takes 1 second
	set_game_speed.emit(current_activity_desired_duration * 3600.0)
	set_time_is_advancing.emit(true)
	
	animation_player.play("do_activity")

func _on_start_activity(activity : ActivityManager.Activity, activity_desired_duration : float, is_yellow_level_attempt : bool, activity_actual_duration : float):
	current_activity = activity
	current_activity_desired_duration = activity_desired_duration
	current_activity_is_yellow_level_attempt = is_yellow_level_attempt
	current_activity_actual_duration = activity_actual_duration

func _on_set_ongoing_activity_panel_visible(p_visible : bool):
	visible = p_visible
	
	if p_visible:
		duration_percentage = current_activity_actual_duration / current_activity_desired_duration
		present_participle = ActivityManager.get_activity_data(current_activity).present_participle
		
		# Yellow level
		if current_activity_is_yellow_level_attempt:
			ongoing_activity_label.text = "Attempting to start " + present_participle + "..."
			
			set_game_speed.emit(GameManager.default_game_speed * ActivityManager.activity_attempt_speed_multiplier)
			set_time_is_advancing.emit(true)
			
			animation_player.play("attempt_activity")
		
		# Green level
		else:
			play_do_activity_animation()

func _on_animation_finished(anim_name):
	match anim_name:
		"attempt_activity":
			if duration_percentage == 0.0:
				set_game_speed.emit(GameManager.default_game_speed)
				set_time_is_advancing.emit(false)
				activity_end_label.text = "Failed to start activity!"
				animation_player.play("show_activity_end_label")
			else:
				play_do_activity_animation()
		
		"do_activity":
			ActivityManager.current_activity = ActivityManager.Activity.IDLE
			set_game_speed.emit(GameManager.default_game_speed)
			set_time_is_advancing.emit(false)
			
			if duration_percentage > 0.98:
				activity_end_label.text = "Done!"
			else:
				activity_end_label.text = "You have had enough of " + present_participle
			
			animation_player.play("show_activity_end_label")
		
		"show_activity_end_label":
			if ThesisWritingManager.thesis_written >= 1.0:
				end_game.emit()
			else:
				set_ongoing_activity_panel_visible.emit(false)
				fade_out_color_rect.emit()
