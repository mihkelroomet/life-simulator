extends PanelContainer

signal set_player_can_move(can_move : bool)
signal set_activity_start_panel_selected_activity(activity : ActivityManager.Activity)

signal start_prevent_pause_menu_timer

const ActivitySelectButton = preload("res://ui/activity_select_button.tscn")
const ActivityDurationVBox = preload("res://ui/activity_duration_vbox.gd")
const ActivityDetailsPanel = preload("res://ui/activity_details_panel.gd")

@onready var radio_button_vbox = $MarginContainer/HBoxContainer/ActivitySelectVBox/RadioButtonVBox
@onready var activity_duration_vbox : ActivityDurationVBox = $MarginContainer/HBoxContainer/ActivitySelectVBox/ActivityDurationVBox
@onready var activity_details_panel : ActivityDetailsPanel = $MarginContainer/HBoxContainer/ActivityDetailsPanel

static var selected_activity_select_button : CheckBox
static var selected_activity : ActivityManager.Activity
## Duration of selected activity in hours.
static var selected_duration : float

func _ready():
	set_player_can_move.connect(Events._on_set_player_can_move)
	set_activity_start_panel_selected_activity.connect(Events._on_set_activity_start_panel_selected_activity)
	start_prevent_pause_menu_timer.connect(Events._on_start_prevent_pause_menu_timer)
	Events.start_activity.connect(_on_start_activity)
	Events.set_activity_select_panel_visible.connect(_on_set_activity_select_panel_visible)
	Events.set_activity_start_panel_selected_activity.connect(_on_set_activity_start_panel_selected_activity)
	Events.set_activity_start_panel_selected_duration.connect(_on_set_activity_start_panel_selected_duration)

func _process(_delta):
	if visible:
		if Input.is_action_just_pressed("ui_cancel"):
			start_prevent_pause_menu_timer.emit()
			toggle_panel(false, [])
		else:
			if Input.is_action_just_pressed("ui_down"):
				select_next_activity()
			
			if Input.is_action_just_pressed("ui_up"):
				select_previous_activity()
			
			if selected_activity != ActivityManager.Activity.IDLE:
				activity_duration_vbox.update_estimated_completion_time(selected_activity)
				activity_details_panel.update_motivation_for_activity(selected_activity)

func toggle_panel(toggled_open : bool, activities : Array[ActivityManager.Activity]):
	visible = toggled_open
	set_player_can_move.emit(!toggled_open)
	if toggled_open:
		selected_activity = ActivityManager.Activity.IDLE # Essentially a reset
		set_activities(activities)
		var first_activity_select_button = radio_button_vbox.get_child(0)
		select_activity(first_activity_select_button)

func set_activities(activities : Array[ActivityManager.Activity]):
	clear_radio_buttons()
	for activity in activities:
		var activity_select_button = ActivitySelectButton.instantiate()
		activity_select_button.activity_select_button_pressed.connect(_on_activity_select_button_pressed)
		# The space at the end is to fix the alignment of the text, which gets offset by an
		# invisible icon on the left. I couldn't find a better solution quickly enough.
		activity_select_button.text = ActivityManager.get_activity_data(activity).display_name + " "
		activity_select_button.activity = activity
		radio_button_vbox.add_child(activity_select_button)

func select_activity(activity_select_button : CheckBox):
	activity_select_button.button_pressed = true
	activity_select_button.pressed.emit()

func select_next_activity():
	var next_activity_index = selected_activity_select_button.get_index() + 1
	if next_activity_index >= radio_button_vbox.get_child_count():
		next_activity_index = 0
	var next_activity = radio_button_vbox.get_child(next_activity_index)
	select_activity(next_activity)

func select_previous_activity():
	var prev_activity_index = selected_activity_select_button.get_index() - 1
	if prev_activity_index <= -1:
		prev_activity_index = radio_button_vbox.get_child_count() - 1
	var prev_activity = radio_button_vbox.get_child(prev_activity_index)
	select_activity(prev_activity)

func clear_radio_buttons():
	for button in radio_button_vbox.get_children():
		radio_button_vbox.remove_child(button)
		button.queue_free()

func _on_start_activity(_activity : ActivityManager.Activity, _activity_desired_duration : float, _is_yellow_level_attempt : bool, _activity_actual_duration : float):
	visible = false

func _on_set_activity_select_panel_visible(p_visible : bool, activities : Array[ActivityManager.Activity]):
	toggle_panel(p_visible, activities)

func _on_activity_select_button_pressed(activity_select_button : CheckBox, activity : ActivityManager.Activity):
	if activity != selected_activity:
		selected_activity_select_button = activity_select_button
		set_activity_start_panel_selected_activity.emit(activity)

func _on_set_activity_start_panel_selected_activity(activity : ActivityManager.Activity):
	selected_activity = activity

func _on_set_activity_start_panel_selected_duration(duration : float):
	selected_duration = duration
