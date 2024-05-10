extends PanelContainer

@onready var settings_panel = $"../SettingsPanel"

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://dialogue/pre-game.tscn")

func _on_settings_button_pressed():
	visible = false
	settings_panel.visible = true

func _on_settings_panel_back_button_pressed():
	settings_panel.visible = false
	visible = true

func _on_quit_button_pressed():
	get_tree().quit()
