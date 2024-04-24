extends PanelContainer

@onready var margin_container = $MarginContainer
@onready var label = $MarginContainer/Label

@export var label_text : String
@export var is_ui_node : bool

var can_become_visible : bool = true

var ui_node_size_multiplier : float = 2.0
var ui_node_bottom_margin : int = 2

func _ready():
	label.text = label_text
	
	if is_ui_node:
		theme_type_variation = "CurvierPanelContainer"
		
		margin_container.add_theme_constant_override("margin_left", margin_container.get_theme_constant("margin_left") * ui_node_size_multiplier)
		margin_container.add_theme_constant_override("margin_right", margin_container.get_theme_constant("margin_right") * ui_node_size_multiplier)
		margin_container.add_theme_constant_override("margin_bottom", ui_node_bottom_margin)
		
		
		label.theme_type_variation = "HeaderMedium"

func show_hotkey(p_visible : bool):
	visible = p_visible and can_become_visible
