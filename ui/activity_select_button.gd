extends CheckBox

signal set_activity_start_panel_selected_activity(activity : Globals.Activity)

const ActivityStartPanel = preload("res://ui/activity_start_panel.gd")

@export var activity : Globals.Activity

func _ready():
	set_activity_start_panel_selected_activity.connect(GameManager._on_set_activity_start_panel_selected_activity)

func _on_button_pressed():
	if activity != ActivityStartPanel.selected_activity:
		set_activity_start_panel_selected_activity.emit(activity)
