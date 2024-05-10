extends VBoxContainer

signal set_default_game_speed(speed : float)

enum PressedKey {NONE, LEFT, RIGHT}

@onready var game_speed_slider = $GameSpeedSlider
@onready var hold_key_delay_timer = $HoldKeyDelayTimer
@onready var repeat_key_timer = $RepeatKeyTimer

var last_pressed_key : PressedKey = PressedKey.NONE

func _ready():
	set_default_game_speed.connect(Events._on_set_default_game_speed)
	
	game_speed_slider.value = GameManager.default_game_speed

func _process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		game_speed_slider.value -= game_speed_slider.step
		last_pressed_key = PressedKey.LEFT
		repeat_key_timer.stop()
		hold_key_delay_timer.start()
	if Input.is_action_just_pressed("ui_right"):
		game_speed_slider.value += game_speed_slider.step
		last_pressed_key = PressedKey.RIGHT
		repeat_key_timer.stop()
		hold_key_delay_timer.start()
	
	if (
		last_pressed_key == PressedKey.LEFT and Input.is_action_just_released("ui_left") or
		last_pressed_key == PressedKey.RIGHT and Input.is_action_just_released("ui_right")
	):
		hold_key_delay_timer.stop()
		repeat_key_timer.stop()

func _on_slider_value_changed(value):
	set_default_game_speed.emit(value)

func _on_hold_key_delay_timer_timeout():
	repeat_key_timer.start()

func _on_repeat_key_timer_timeout():
	if last_pressed_key == PressedKey.LEFT:
		game_speed_slider.value -= game_speed_slider.step
	elif last_pressed_key == PressedKey.RIGHT:
		game_speed_slider.value += game_speed_slider.step
