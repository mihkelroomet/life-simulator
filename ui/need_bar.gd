extends Button

const CustomProgressBar = preload("res://ui/progress_bar.gd")

@onready var progress_bar : CustomProgressBar = $MarginContainer/VBoxContainer/ProgressBarHBox
@onready var label = $MarginContainer/VBoxContainer/Label

@export var need : Globals.Need

func _ready():
	Events.need_satisfaction_changed.connect(_on_need_satisfaction_changed)
	label.text = Globals.NEED_NAMES[need]

func _on_need_satisfaction_changed(changed_need, new_value):
	if need == changed_need:
		progress_bar.set_value(new_value)
