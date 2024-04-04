extends PanelContainer

signal set_time_is_advancing(if_is_advancing : bool)
signal set_player_can_move(if_can_move : bool)
signal fade_in_color_rect

const ActivitySelectButton = preload("res://ui/activity_select_button.tscn")

@onready var radio_button_vbox = $MarginContainer/VBoxContainer/RadioButtonVBox

func _ready():
	GameManager.set_activity_start_panel_visible.connect(_on_set_activity_start_panel_visible)
	set_time_is_advancing.connect(GameManager._on_set_time_is_advancing)
	set_player_can_move.connect(GameManager._on_set_player_can_move)
	fade_in_color_rect.connect(GameManager._on_fade_in_color_rect)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and visible:
		toggle_panel(false)

func toggle_panel(if_toggled_open : bool):
	visible = if_toggled_open
	set_time_is_advancing.emit(!if_toggled_open)
	set_player_can_move.emit(!if_toggled_open)

func set_activities(activities : Array[Globals.Activity]):
	clear_radio_buttons()
	for activity in activities:
		var activity_select_button = ActivitySelectButton.instantiate()
		# The space at the end is to fix the alignment of the text, which gets offset by an
		# invisible icon on the left. I couldn't find a better solution quickly enough.
		activity_select_button.text = Globals.get_activity_data(activity).display_name + " "
		activity_select_button.activity = activity
		radio_button_vbox.add_child(activity_select_button)

func clear_radio_buttons():
	for button in radio_button_vbox.get_children():
		radio_button_vbox.remove_child(button)
		button.queue_free()

func _on_set_activity_start_panel_visible(if_visible : bool, activities : Array[Globals.Activity]):
	toggle_panel(if_visible)
	if if_visible:
		set_activities(activities)

func _on_start_button_pressed():
	visible = false
	fade_in_color_rect.emit()
