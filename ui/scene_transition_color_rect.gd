extends Control

signal set_player_can_move(can_move : bool)

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	set_player_can_move.connect(Events._on_set_player_can_move)
	Events.end_game.connect(_on_end_game)
	
	animation_player.play("fade_out")

func _on_end_game():
	visible = true
	animation_player.play("fade_in")

func _on_animation_finished(anim_name):
	if anim_name == "fade_in":
		get_tree().change_scene_to_file("res://dialogue/post-game.tscn")
	elif anim_name == "fade_out":
		visible = false
		set_player_can_move.emit(true)
