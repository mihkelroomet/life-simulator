extends Node2D

signal set_time_is_advancing(if_advancing : bool)
signal set_player_can_move(can_move : bool)

@export var dialogic_timeline : String
@export var next_scene : Resource

func _ready():
	set_time_is_advancing.connect(Events._on_set_time_is_advancing)
	set_player_can_move.connect(Events._on_set_player_can_move)
	
	Dialogic.timeline_ended.connect(transition_to_next_scene)
	
	set_time_is_advancing.emit(false)
	set_player_can_move.emit(false)
	start_dialogue()

func start_dialogue():
	Dialogic.start(dialogic_timeline)

func transition_to_next_scene():
	Dialogic.timeline_ended.disconnect(transition_to_next_scene)
	get_tree().change_scene_to_file(next_scene.resource_path)
