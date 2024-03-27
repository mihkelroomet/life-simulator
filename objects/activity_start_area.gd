extends Node

signal activity_start_panel_visible_set(if_visible : bool, activities : Array[Globals.Activity])

@onready var hotkey_popup_panel = $HotkeyPopupPanel

@export var activities : Array[Globals.Activity]

var player_is_in_area : bool = false

func _ready():
	activity_start_panel_visible_set.connect(GameManager._on_activity_start_panel_visible_set)

func _process(_delta):
	if Input.is_action_just_pressed("interact") and player_is_in_area:
		activity_start_panel_visible_set.emit(true, activities)

func _on_body_entered(_body):
	player_is_in_area = true
	hotkey_popup_panel.visible = true

func _on_body_exited(_body):
	player_is_in_area = false
	hotkey_popup_panel.visible = false
