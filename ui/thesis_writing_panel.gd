extends MarginContainer

@onready var progress_bar = $VBoxContainer/ThesisWritingBar/MarginContainer/VBoxContainer/MarginContainer/ProgressBar
@onready var progress_percentage_label = $VBoxContainer/ThesisWritingBar/MarginContainer/VBoxContainer/MarginContainer/ProgressBar/ProgressPercentageLabel

func _ready():
	Events.thesis_written_amount_changed.connect(_on_thesis_written_amount_changed)

func _on_thesis_written_amount_changed(new_value : float):
	set_progress_bar_value(new_value)

# Sets the value of the progress bar. The input value should be in range [0.0, 1.0].
func set_progress_bar_value(value):
	progress_bar.value = progress_bar.min_value + value * (progress_bar.max_value - progress_bar.min_value)	
	progress_percentage_label.text = str(progress_bar.value, "% (" + ThesisWritingManager.get_grade() + ")")
