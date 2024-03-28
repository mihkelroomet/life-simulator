extends PanelContainer

signal set_game_is_running(if_running : bool)

@onready var radio_button_vbox = $MarginContainer/VBoxContainer/RadioButtonVBox

func _ready():
	GameManager.activity_start_panel_visible_set.connect(_on_activity_start_panel_visible_set)
	set_game_is_running.connect(GameManager._on_set_game_is_running)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and visible:
		set_panel_visible(false)

func set_panel_visible(if_visible : bool):
	visible = if_visible
	set_game_is_running.emit(!if_visible)

func set_activities(activities : Array[Globals.Activity]):
	clear_radio_buttons()
	for activity in activities:
		var button = Button.new()
		button.text = Globals.get_activity_data(activity).display_name
		radio_button_vbox.add_child(button)

func clear_radio_buttons():
	for button in radio_button_vbox.get_children():
		radio_button_vbox.remove_child(button)
		button.queue_free()

func _on_activity_start_panel_visible_set(if_visible : bool, activities : Array[Globals.Activity]):
	set_panel_visible(if_visible)
	if if_visible:
		set_activities(activities)
