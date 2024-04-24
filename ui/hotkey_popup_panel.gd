extends PanelContainer

@onready var label = $Label

@export var label_text : String
@export var is_ui_node : bool

var can_become_visible : bool = true

var ui_node_size_multiplier : float = 2.0

func _ready():
	label.text = label_text
	
	if is_ui_node:
		theme_type_variation = "CurvierPanelContainer"
		custom_minimum_size *= ui_node_size_multiplier
		label.theme_type_variation = "HeaderMedium"

func show_hotkey(p_visible : bool):
	visible = p_visible and can_become_visible
