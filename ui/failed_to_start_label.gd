extends Label

@onready var failed_to_start_label_timer = $FailedToStartLabelTimer

func _ready():
	Events.fail_to_start_activity.connect(_on_failed_to_start_activity)
	Events.set_activity_select_panel_visible.connect(_on_set_activity_select_panel_visible)

func _on_failed_to_start_activity():
	visible = true
	failed_to_start_label_timer.start()

func _on_set_activity_select_panel_visible(p_visible : bool, _activities : Array[ActivityManager.Activity]):
	if p_visible:
		visible = false

func _on_timer_timeout():
	visible = false
