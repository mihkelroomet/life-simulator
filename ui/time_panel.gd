extends PanelContainer

@onready var time_label : Label = $MarginContainer/VBoxContainer/Time
@onready var day_of_week_label : Label = $MarginContainer/VBoxContainer/DayOfWeek
@onready var day_of_year_label : Label = $MarginContainer/VBoxContainer/DayOfYear
@onready var timer : Timer = $TimeChangeTimer

var WEEKDAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
var MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

func _ready():
	GameManager.set_time_is_advancing.connect(_on_set_time_is_advancing)

func set_time(unix_time):
	var datetime_dict = Time.get_datetime_dict_from_unix_time(unix_time)
	time_label.text = get_time_from_datetime_dict(datetime_dict)
	day_of_week_label.text = WEEKDAYS[datetime_dict["weekday"]]
	day_of_year_label.text = get_day_of_year_from_datetime_dict(datetime_dict)

func _on_set_time_is_advancing(if_is_advancing : bool):
	timer.paused = !if_is_advancing

func _on_timer_timeout():
	Globals.game_time += timer.wait_time * Globals.game_speed
	set_time(Globals.game_time)
	
func get_time_from_datetime_dict(datetime_dict):
	var hour = datetime_dict["hour"]
	var minute = str(datetime_dict["minute"]).pad_zeros(2)
	
	var suffix = "AM"
	
	if (hour >= 12):
		suffix = "PM"
		if (hour >= 13):
			hour -= 12
	
	if (hour == 0):
		hour = 12
	
	hour = str(hour)
	
	return hour + ":" + minute + " " + suffix

func get_day_of_year_from_datetime_dict(datetime_dict):
	var month = MONTHS[datetime_dict["month"] - 1]
	var day = str(datetime_dict["day"])
	var year = str(datetime_dict["year"])
	
	return month + " " + day + " " + year
