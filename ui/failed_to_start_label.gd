extends Label

@onready var failed_to_start_label_timer = $FailedToStartLabelTimer

func _ready():
	Events.fail_to_start_activity.connect(_on_failed_to_start_activity)

func _on_failed_to_start_activity():
	visible = true
	failed_to_start_label_timer.start()

func _on_timer_timeout():
	visible = false
