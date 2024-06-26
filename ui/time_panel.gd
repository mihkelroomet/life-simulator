extends MarginContainer

signal set_game_time(time : float)

@onready var time_label : Label = $PanelContainer/MarginContainer/VBoxContainer/Time
@onready var day_of_week_label : Label = $PanelContainer/MarginContainer/VBoxContainer/DayOfWeek
@onready var day_of_year_label : Label = $PanelContainer/MarginContainer/VBoxContainer/DayOfYear
@onready var timer : Timer = $TimeChangeTimer

func _ready():
	set_game_time.connect(Events._on_set_game_time)
	Events.set_time_is_advancing.connect(_on_set_time_is_advancing)

func set_time(unix_time):
	time_label.text = TimeUtils.get_time_from_unix_time(unix_time)
	day_of_week_label.text = TimeUtils.get_day_of_week_from_unix_time(unix_time)
	day_of_year_label.text = TimeUtils.get_day_of_year_from_unix_time(unix_time)

func _on_set_time_is_advancing(is_advancing : bool):
	timer.paused = !is_advancing

func _on_timer_timeout():
	var new_time = GameManager.game_time + timer.wait_time * GameManager.game_speed
	set_time(new_time)
	set_game_time.emit(new_time)
