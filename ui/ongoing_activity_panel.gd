extends MarginContainer

signal set_game_speed(speed : float)
signal set_time_is_advancing(if_advancing : bool)
signal fade_out_color_rect
signal set_ongoing_activity_panel_visible(if_visible : bool)

@onready var ongoing_activity_label = $PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/OngoingActivityLabel
@onready var activity_end_label = $PanelContainer/MarginContainer/VBoxContainer2/ActivityEndLabel
@onready var animation_player = $AnimationPlayer

var duration_percentage : float
var present_participle : String
## This variable keeps track of current activity to enable switching to idle for the duration
## of attempting to start an activity.
var activity : Globals.Activity
## Controls how much faster time advances during an attemp to start an activity compared to
## regular idling.
var attempt_speed_multiplier : float = 5.0

func _ready():
	set_game_speed.connect(Events._on_set_game_speed)
	set_time_is_advancing.connect(Events._on_set_time_is_advancing)
	fade_out_color_rect.connect(Events._on_fade_out_color_rect)
	set_ongoing_activity_panel_visible.connect(Events._on_set_ongoing_activity_panel_visible)
	Events.set_ongoing_activity_panel_visible.connect(_on_set_ongoing_activity_panel_visible)

func play_do_activity_animation():
	var do_activity_animation : Animation = animation_player.get_animation("do_activity")
	do_activity_animation.track_set_key_value(0, 1, duration_percentage * 100)
	do_activity_animation.track_set_key_time(0, 1, duration_percentage)
	do_activity_animation.length = duration_percentage
	
	ongoing_activity_label.text = present_participle + "..."
	
	# This assumes the full "do_activity" animation takes 1 second
	set_game_speed.emit(Globals.current_activity_desired_duration * 3600.0)
	set_time_is_advancing.emit(true)
	
	animation_player.play("do_activity")

func _on_set_ongoing_activity_panel_visible(if_visible : bool):
	visible = if_visible
	
	if visible:
		set_time_is_advancing.emit(false)
		duration_percentage = Globals.current_activity_actual_duration / Globals.current_activity_desired_duration
		present_participle = Globals.get_current_activity_data().present_participle
		
		# Yellow level
		if Globals.current_activity_is_yellow_level_attempt:
			ongoing_activity_label.text = "Attempting to start " + present_participle + "..."
			
			# Temporarily change activity to idle for the duration of the attempt
			activity = Globals.current_activity
			Globals.current_activity = Globals.Activity.IDLE
			set_game_speed.emit(Globals.DEFAULT_GAME_SPEED * attempt_speed_multiplier)
			set_time_is_advancing.emit(true)
			
			animation_player.play("attempt_activity")
		
		# Green level
		else:
			play_do_activity_animation()

func _on_animation_finished(anim_name):
	match anim_name:
		"attempt_activity":
			# Change the activity back from idle
			Globals.current_activity = activity
			set_game_speed.emit(Globals.DEFAULT_GAME_SPEED)
			set_time_is_advancing.emit(false)
			
			if duration_percentage == 0.0:
				activity_end_label.text = "Failed to start activity!"
				animation_player.play("show_activity_end_label")
			else:
				play_do_activity_animation()
		"do_activity":
			set_game_speed.emit(Globals.DEFAULT_GAME_SPEED)
			set_time_is_advancing.emit(false)
			if duration_percentage > 0.98:
				activity_end_label.text = "Done!"
			else:
				activity_end_label.text = "You have had enough of " + present_participle
			animation_player.play("show_activity_end_label")
		"show_activity_end_label":
			set_ongoing_activity_panel_visible.emit(false)
			fade_out_color_rect.emit()
