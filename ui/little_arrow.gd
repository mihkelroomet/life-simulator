extends TextureRect

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

var is_on : bool = false

func ping() -> void:
	if !is_on:
		fade_in(true)
		is_on = true
	timer.start()

func fade_in(fading_in : bool):
	if fading_in:
		animation_player.play("fade_in")
	else:
		animation_player.play_backwards("fade_in")

func _on_timer_timeout():
	fade_in(false)
	is_on = false
