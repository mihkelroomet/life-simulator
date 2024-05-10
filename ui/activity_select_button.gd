extends CheckBox

signal activity_select_button_pressed(activity : ActivityManager.Activity)

@export var activity : ActivityManager.Activity

func _on_button_pressed():
	activity_select_button_pressed.emit(self, activity)
