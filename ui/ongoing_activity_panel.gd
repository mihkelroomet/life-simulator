extends MarginContainer

@onready var ongoing_activity_label = $PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/OngoingActivityLabel

func _ready():
	GameManager.set_ongoing_activity_panel_visible.connect(_on_set_ongoing_activity_panel_visible)

func _on_set_ongoing_activity_panel_visible(if_visible : bool):
	visible = if_visible
	var present_participle : String = Globals.get_current_activity_data().present_participle
	ongoing_activity_label.text = present_participle + "..."
