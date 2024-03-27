extends Node

@onready var hotkey_popup_panel = $HotkeyPopupPanel

func _on_body_entered(body):
	hotkey_popup_panel.visible = true

func _on_body_exited(body):
	hotkey_popup_panel.visible = false
