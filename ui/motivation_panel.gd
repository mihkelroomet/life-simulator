extends MarginContainer

@onready var expanding_bars = $VBoxContainer/ExpandingBars

## Whether the user last decided to open or close the panel.
var panel_opened_by_user : bool = false
var user_can_toggle_panel : bool = true

func _ready():
	Events.start_activity.connect(_on_start_activity)
	Events.stop_activity.connect(_on_stop_activity)
	toggle_motivation_bar(panel_opened_by_user)

func _process(_delta):
	if Input.is_action_just_pressed("open_motivation_bar"):
		var toggled_open : bool = !expanding_bars.visible
		toggle_motivation_bar(toggled_open)

func toggle_motivation_bar(toggled_open):
	# The second case is for keeping the panel open if the user had it open before activity start
	expanding_bars.visible = toggled_open or !toggled_open and !user_can_toggle_panel and panel_opened_by_user
	if user_can_toggle_panel:
		panel_opened_by_user = toggled_open

func _on_motivation_bar_toggled(toggled_open):
	toggle_motivation_bar(toggled_open)

func _on_start_activity(_activity : ActivityManager.Activity, _activity_desired_duration : float, _is_yellow_level_attempt : bool, _activity_actual_duration : float):
	user_can_toggle_panel = false

func _on_stop_activity():
	user_can_toggle_panel = true
