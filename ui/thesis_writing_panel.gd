extends MarginContainer

@onready var progress_bar = $VBoxContainer/ThesisWritingBar/MarginContainer/VBoxContainer/MarginContainer/ProgressBar
@onready var progress_percentage_label = $VBoxContainer/ThesisWritingBar/MarginContainer/VBoxContainer/MarginContainer/ProgressBar/ProgressPercentageLabel

var grade_thresholds : Array[float] = [51.0, 61.0, 71.0, 81.0, 91.0, 10000.0]
var grades : Array[String] = ["F", "E", "D", "C", "B", "A"]

func _ready():
	Events.thesis_written_amount_changed.connect(_on_thesis_written_amount_changed)

func _on_thesis_written_amount_changed(new_value : float):
	set_progress_bar_value(new_value)

# Sets the value of the progress bar. The input value should be in range [0.0, 1.0].
func set_progress_bar_value(new_value):
	progress_bar.value = progress_bar.min_value + new_value * (progress_bar.max_value - progress_bar.min_value)

func _on_progress_bar_value_changed(value):
	var grade : String
	
	for i in range(grade_thresholds.size()):
		if value < grade_thresholds[i]:
			grade = grades[i]
			break
	
	progress_percentage_label.text = str(value, "% (" + grade + ")")
