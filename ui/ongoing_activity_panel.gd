extends MarginContainer

signal set_game_speed(speed : float)
signal set_time_is_advancing(if_advancing : bool)
signal fade_out_color_rect
signal set_ongoing_activity_panel_visible(if_visible : bool)

@onready var ongoing_activity_label = $PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/OngoingActivityLabel
@onready var animation_player = $AnimationPlayer

func _ready():
	set_game_speed.connect(Events._on_set_game_speed)
	set_time_is_advancing.connect(Events._on_set_time_is_advancing)
	fade_out_color_rect.connect(Events._on_fade_out_color_rect)
	set_ongoing_activity_panel_visible.connect(Events._on_set_ongoing_activity_panel_visible)
	Events.set_ongoing_activity_panel_visible.connect(_on_set_ongoing_activity_panel_visible)

func _on_set_ongoing_activity_panel_visible(if_visible : bool):
	visible = if_visible
	
	if visible:
		var present_participle : String = Globals.get_current_activity_data().present_participle
		ongoing_activity_label.text = present_participle + "..."
		
		# This assumes the "do_activity" animation takes 1 second
		set_game_speed.emit(Globals.current_activity_duration * 3600.0)
		set_time_is_advancing.emit(true)
		
		animation_player.play("do_activity")

func _on_animation_finished(anim_name):
	if anim_name == "do_activity":
		set_game_speed.emit(Globals.DEFAULT_GAME_SPEED)
		set_time_is_advancing.emit(false)
		animation_player.play("show_done_label")
	elif anim_name == "show_done_label":
		set_ongoing_activity_panel_visible.emit(false)
		fade_out_color_rect.emit()
