extends Node

signal set_activity_select_panel_visible(is_visible : bool, activities : Array[ActivityManager.Activity])

@onready var hotkey_popup_panel = $HotkeyPopupPanel

@export var activities : Array[ActivityManager.Activity]

var player_is_in_area : bool = false

func _ready():
	set_activity_select_panel_visible.connect(Events._on_set_activity_select_panel_visible)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and player_is_in_area and GameManager.player_can_move:
		set_activity_select_panel_visible.emit(true, activities)

func _on_body_entered(_body):
	player_is_in_area = true
	hotkey_popup_panel.visible = true

func _on_body_exited(_body):
	player_is_in_area = false
	hotkey_popup_panel.visible = false
