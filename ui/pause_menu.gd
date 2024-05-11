extends Control

signal set_time_is_advancing(is_advancing : bool)
signal set_player_can_move(can_move : bool)

@onready var mouse_eater_color_rect = $MouseEaterColorRect
@onready var prevent_pause_menu_timer = $PreventPauseMenuTimer

var can_be_triggered_by_key_press : bool = true

func _ready():
	set_time_is_advancing.connect(Events._on_set_time_is_advancing)
	set_player_can_move.connect(Events._on_set_player_can_move)
	Events.set_pause_menu_active.connect(_on_set_pause_menu_active)
	Events.start_prevent_pause_menu_timer.connect(_on_start_prevent_pause_menu_timer)

func _process(_delta):
	if can_be_triggered_by_key_press:
		if Input.is_action_just_pressed("ui_cancel"):
			if GameManager.time_is_advancing and GameManager.player_can_move:
				set_active(true)
			elif visible:
				set_active(false)

func set_active(active : bool):
	visible = active
	set_time_is_advancing.emit(!active)
	set_player_can_move.emit(!active)

func _on_set_pause_menu_active(active : bool):
	set_active(active)

func _on_start_prevent_pause_menu_timer():
	can_be_triggered_by_key_press = false
	prevent_pause_menu_timer.start()

func _on_resume_button_pressed():
	set_active(false)

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_prevent_pause_menu_timer_timeout():
	can_be_triggered_by_key_press = true
