extends Button

const CustomProgressBar = preload("res://ui/progress_bar.gd")

@onready var progress_bar : CustomProgressBar = $MarginContainer/VBoxContainer/ProgressBarHBox
@onready var label = $MarginContainer/VBoxContainer/Label
@onready var tooltip_label = $TooltipPanel/MarginContainer/TooltipLabel
@onready var tooltip_animation_player = $TooltipPanel/TooltipAnimationPlayer

@export var need : NeedManager.Need

func _ready():
	Events.need_satisfaction_changed.connect(_on_need_satisfaction_changed)
	label.text = NeedManager.NEED_NAMES[need]
	tooltip_label.text = NeedManager.NEED_DESCRIPTIONS[need]

func _on_need_satisfaction_changed(changed_need, new_value):
	if need == changed_need:
		progress_bar.set_value(new_value)

func _on_mouse_entered():
	tooltip_animation_player.play("delayed_fade_in")

func _on_mouse_exited():
	tooltip_animation_player.stop()
