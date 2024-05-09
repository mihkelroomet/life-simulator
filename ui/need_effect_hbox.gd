extends HBoxContainer

@onready var need_abbr_label = $NeedAbbrLabel
@onready var effect_label = $EffectLabel

@export var need : NeedManager.Need

func _ready():
	need_abbr_label.text = NeedManager.NEED_NAMES_ABBR[need]
