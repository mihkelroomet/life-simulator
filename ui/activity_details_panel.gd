extends Control

const CustomProgressBar = preload("res://ui/progress_bar.gd")

@onready var instruction_label = $InstructionLabel
@onready var activity_details_vbox = $ActivityDetailsVBox
@onready var motivation_for_activity_progress_bar : CustomProgressBar = $ActivityDetailsVBox/MotvationForActivityVBox/MotivationForActivityProgressBar

func _ready():
	Events.set_activity_start_panel_visible.connect(_on_set_activity_start_panel_visible)
	Events.set_activity_start_panel_selected_activity.connect(_on_set_activity_start_panel_selected_activity)

func toggle_panel(toggled_on : bool):
	instruction_label.visible = !toggled_on
	activity_details_vbox.visible = toggled_on

func update_motivation_for_activity(activity : ActivityManager.Activity):
	var motivation_for_activity = ActivityManager.get_motivation_for_activity(activity)
	motivation_for_activity_progress_bar.set_value(motivation_for_activity)

func _on_set_activity_start_panel_visible(p_visible : bool, _activities : Array[ActivityManager.Activity]):
	if p_visible:
		toggle_panel(false)

func _on_set_activity_start_panel_selected_activity(_activity : ActivityManager.Activity):
	toggle_panel(true)
	motivation_for_activity_progress_bar.reset()
