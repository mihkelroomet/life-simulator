extends Node2D

var speed: int = 400


func _process(delta):
	position += Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed * delta
