extends VBoxContainer

@onready var expanding_bars = $ExpandingBars

func _on_motivation_bar_toggled(toggled_on):
	expanding_bars.visible = toggled_on
