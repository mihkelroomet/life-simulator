extends PanelContainer

signal game_is_running_set(if_running : bool)

func _ready():
	GameManager.activity_start_panel_visible_set.connect(_on_activity_start_panel_visible_set)
	game_is_running_set.connect(GameManager._on_game_is_running_set)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and visible:
		set_panel_visible(false)

func set_panel_visible(if_visible : bool):
	visible = if_visible
	game_is_running_set.emit(!if_visible)

func _on_activity_start_panel_visible_set(if_visible : bool, activities : Array[Globals.Activity]):
	set_panel_visible(if_visible)
