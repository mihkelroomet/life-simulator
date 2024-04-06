extends MarginContainer

@onready var expanding_bars = $VBoxContainer/ExpandingBars

func _process(delta):
	if Input.is_action_just_pressed("open_motivation_bar"):
		var if_toggled_open = !expanding_bars.visible
		toggle_motivation_bar(if_toggled_open)

func toggle_motivation_bar(if_toggled_open):
	expanding_bars.visible = if_toggled_open

func _on_motivation_bar_toggled(if_toggled_open):
	toggle_motivation_bar(if_toggled_open)
