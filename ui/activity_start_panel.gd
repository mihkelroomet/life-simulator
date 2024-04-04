extends PanelContainer

signal set_current_activity(activity : Globals.Activity, activity_duration : float)
signal set_time_is_advancing(if_is_advancing : bool)
signal set_player_can_move(if_can_move : bool)
signal fade_in_color_rect

const ActivitySelectButton = preload("res://ui/activity_select_button.tscn")

@onready var radio_button_vbox = $MarginContainer/VBoxContainer/RadioButtonVBox

static var selected_activity : Globals.Activity
static var selected_duration : float

func _ready():
	set_current_activity.connect(GameManager._on_set_current_activity)
	set_time_is_advancing.connect(GameManager._on_set_time_is_advancing)
	set_player_can_move.connect(GameManager._on_set_player_can_move)
	fade_in_color_rect.connect(GameManager._on_fade_in_color_rect)
	GameManager.set_activity_start_panel_visible.connect(_on_set_activity_start_panel_visible)
	GameManager.set_activity_start_panel_selected_activity.connect(_on_set_activity_start_panel_selected_activity)
	GameManager.set_activity_start_panel_selected_duration.connect(_on_set_activity_start_panel_selected_duration)

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

func _on_set_activity_start_panel_selected_activity(activity : Globals.Activity):
	selected_activity = activity

func _on_set_activity_start_panel_selected_duration(duration : int):
	selected_duration = duration

func _on_start_button_pressed():
	if selected_activity != Globals.Activity.IDLE and selected_duration > 0.0:
		visible = false
		set_current_activity.emit(selected_activity, selected_duration)
		fade_in_color_rect.emit()
