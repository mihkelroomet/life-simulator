extends Control

signal set_player_can_move(if_can_move : bool)
signal set_time_is_advancing(if_advancing : bool)
signal set_ongoing_activity_panel_visible(if_visible : bool)

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	set_player_can_move.connect(GameManager._on_set_player_can_move)
	set_time_is_advancing.connect(GameManager._on_set_time_is_advancing)
	set_ongoing_activity_panel_visible.connect(GameManager._on_set_ongoing_activity_panel_visible)
	GameManager.start_activity.connect(_on_start_activity)
	GameManager.fade_out_color_rect.connect(_on_fade_out_color_rect)

func _on_start_activity(_activity : Globals.Activity, _duration : float):
	animation_player.play("fade_in")

func _on_fade_out_color_rect():
	animation_player.play("fade_out")

func _on_animation_finished(anim_name):
	if anim_name == "fade_in":
		set_ongoing_activity_panel_visible.emit(true)
	elif anim_name == "fade_out":
		set_player_can_move.emit(true)
		set_time_is_advancing.emit(true)
