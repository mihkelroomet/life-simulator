extends TextureRect

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var timer = $Timer

var is_on : bool = false

## Fades arrow in. Arrow will fade out again if it hasn't received any pings for a set time.
func ping() -> void:
	if !is_on:
		fade_in()
		is_on = true
	timer.start()

## Immediately hides arrow
func hide_arrow() -> void:
	animation_player.stop()
	is_on = false

func fade_in():
	animation_player.play("fade_in")

func fade_out():
	animation_player.play_backwards("fade_in")

func _on_timer_timeout():
	if is_on:
		fade_out()
		is_on = false
