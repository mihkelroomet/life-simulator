extends Node2D

@onready var main_menu_panel = $CanvasLayer/MainMenuPanel
@onready var settings_panel = $CanvasLayer/SettingsPanel

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://dialogue/pre-game.tscn")

func _on_settings_button_pressed():
	main_menu_panel.visible = false
	settings_panel.visible = true

func _on_settings_panel_back_button_pressed():
	settings_panel.visible = false
	main_menu_panel.visible = true

func _on_quit_button_pressed():
	get_tree().quit()
