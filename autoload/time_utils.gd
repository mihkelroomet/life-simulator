extends Node

const WEEKDAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

func get_time_from_unix_time(unix_time):
	var datetime_dict = Time.get_datetime_dict_from_unix_time(unix_time)
	return get_time_from_datetime_dict(datetime_dict)

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

func get_day_of_week_from_unix_time(unix_time):
	var datetime_dict = Time.get_datetime_dict_from_unix_time(unix_time)
	return get_day_of_week_from_datetime_dict(datetime_dict)

func get_day_of_week_from_datetime_dict(datetime_dict):
	return WEEKDAYS[datetime_dict["weekday"]]

func get_day_of_year_from_unix_time(unix_time):
	var datetime_dict = Time.get_datetime_dict_from_unix_time(unix_time)
	return get_day_of_year_from_datetime_dict(datetime_dict)

func get_day_of_year_from_datetime_dict(datetime_dict):
	var month = MONTHS[datetime_dict["month"] - 1]
	var day = str(datetime_dict["day"])
	var year = str(datetime_dict["year"])
	
	return month + " " + day + " " + year
