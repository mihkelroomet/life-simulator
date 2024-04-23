extends CheckBox

signal activity_select_button_pressed(activity : Globals.Activity)

@export var activity : Globals.Activity

func _on_button_pressed():
	activity_select_button_pressed.emit(activity)
