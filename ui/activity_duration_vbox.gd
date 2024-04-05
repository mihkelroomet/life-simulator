extends VBoxContainer

signal set_activity_start_panel_selected_duration(duration : int)

const ActivityStartPanel = preload("res://ui/activity_start_panel.gd")

@onready var activity_duration_label = $ActivityDurationLabel
@onready var activity_duration_slider = $ActivityDurationSlider

func _ready():
	set_activity_start_panel_selected_duration.connect(GameManager._on_set_activity_start_panel_selected_duration)
	GameManager.set_activity_start_panel_visible.connect(_on_set_activity_start_panel_visible)
	GameManager.set_activity_start_panel_selected_activity.connect(_on_set_activity_start_panel_selected_activity)

func set_duration(quarters_of_hour : int):
	var hours : int = floor(quarters_of_hour / 4.0)
	var minutes : int = quarters_of_hour % 4 * 15
	
	var text : String = ""
	if hours != 0:
		text = str(hours) + "h "
	text += str(minutes) + "min"
	
	activity_duration_label.text = text
	
	set_activity_start_panel_selected_duration.emit(quarters_of_hour)

func _on_set_activity_start_panel_visible(if_visible : bool, _activities : Array[Globals.Activity]):
	if if_visible:
		activity_duration_slider.min_value = 0
		activity_duration_slider.max_value = 1
		activity_duration_slider.value = 0
		activity_duration_slider.editable = false
		activity_duration_label.text = "?h ?min"

func _on_set_activity_start_panel_selected_activity(activity : Globals.Activity):
	if activity != ActivityStartPanel.selected_activity:
		var activity_data = Globals.get_activity_data(activity)
		
		var min_quarters_of_hour = round(activity_data.min_duration / 0.25)
		var max_quarters_of_hour = round(activity_data.max_duration / 0.25)
		var default_quarters_of_hour = round(activity_data.default_duration / 0.25)
		
		activity_duration_slider.min_value = min_quarters_of_hour
		activity_duration_slider.max_value = max_quarters_of_hour
		activity_duration_slider.value = default_quarters_of_hour
		
		set_duration(default_quarters_of_hour)
		
		# Disable slider if there is only one possible duration, enable it otherwise
		if min_quarters_of_hour == default_quarters_of_hour and default_quarters_of_hour == max_quarters_of_hour:
			activity_duration_slider.editable = false
		else:
			activity_duration_slider.editable = true

func _on_activity_duration_slider_value_changed(value):
	set_duration(value)
