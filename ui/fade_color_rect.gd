extends Control

signal set_player_can_move(if_can_move : bool)

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	set_player_can_move.connect(GameManager._on_set_player_can_move)
	GameManager.fade_in_color_rect.connect(_on_fade_in_color_rect)
	GameManager.fade_out_color_rect.connect(_on_fade_out_color_rect)

func _on_fade_in_color_rect():
	animation_player.play("fade_in")

func _on_fade_out_color_rect():
	animation_player.play("fade_out")

func _on_animation_finished(anim_name):
	# Temp for testing
	if anim_name == "fade_in":
		_on_fade_out_color_rect()
	elif anim_name == "fade_out":
		set_player_can_move.emit(true)
