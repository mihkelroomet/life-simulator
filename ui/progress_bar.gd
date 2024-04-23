extends HBoxContainer

const LittleArrow = preload("res://ui/little_arrow.gd")

@onready var progress_bar = $ProgressBar

@onready var left_arrow_1 : LittleArrow = $LeftArrowHBox/LeftArrow1
@onready var left_arrow_2 : LittleArrow = $LeftArrowHBox/LeftArrow2
@onready var left_arrow_3 : LittleArrow = $LeftArrowHBox/LeftArrow3

@onready var right_arrow_1 : LittleArrow = $RightArrowHBox/RightArrow1
@onready var right_arrow_2 : LittleArrow = $RightArrowHBox/RightArrow2
@onready var right_arrow_3 : LittleArrow = $RightArrowHBox/RightArrow3

const NEGATIVE_THRESHOLD_2_3 : float = -10.0
const NEGATIVE_THRESHOLD_1_2 : float = -0.8
const NEGATIVE_THRESHOLD_0_1 : float = -0.1

const POSITIVE_THRESHOLD_0_1 : float = 0.1
const POSITIVE_THRESHOLD_1_2 : float = 0.8
const POSITIVE_THRESHOLD_2_3 : float = 10.0

var left_arrows : Array[LittleArrow]
var right_arrows : Array[LittleArrow]
var neg_thresholds : Array[float]
var pos_thresholds : Array[float]

var min_hue : float = 0
var max_hue : float = 0.33
var saturation : float = 0.4
var lightness_value : float = 0.8
var alpha: float = 1

var last_value : float = -1.0 # -1 represents uninitialized value

## Percentage of bar that is filled at 0% motivation. This is because for the player to
## understand the bar is empty it is more intuitive to have a bit of the filling showing.
var empty_value_percentage : float = 0.02
## Bar value at 0% motivation. Gets set at runtime.
var empty_value : float

func _ready():
	left_arrows = [left_arrow_1, left_arrow_2, left_arrow_3]
	right_arrows = [right_arrow_1, right_arrow_2, right_arrow_3]
	neg_thresholds = [NEGATIVE_THRESHOLD_0_1, NEGATIVE_THRESHOLD_1_2, NEGATIVE_THRESHOLD_2_3]
	pos_thresholds = [POSITIVE_THRESHOLD_0_1, POSITIVE_THRESHOLD_1_2, POSITIVE_THRESHOLD_2_3]
	
	empty_value = progress_bar.min_value + empty_value_percentage * (progress_bar.max_value - progress_bar.min_value)

func _process(delta):
	if last_value != -1.0:
		ping_arrows(delta)
	last_value = progress_bar.value

func ping_arrows(delta):
	var change = progress_bar.value - last_value
	var change_per_second = change / delta
	
	# If change is positive
	if change_per_second > 0:
		for i in range(right_arrows.size()):
			if change_per_second >= pos_thresholds[i]:
				right_arrows[i].ping()
		for left_arrow in left_arrows:
			left_arrow.hide_arrow()
	
	# If change is negative
	elif change_per_second < 0:
		for i in range(left_arrows.size()):
			if change_per_second <= neg_thresholds[i]:
				left_arrows[i].ping()
		for right_arrow in right_arrows:
			right_arrow.hide_arrow()

func set_value(new_value):
	progress_bar.value = empty_value + new_value * (progress_bar.max_value - empty_value)
	
	var value_percent = (progress_bar.value - empty_value) / (progress_bar.max_value - empty_value)
	var hue = min_hue + (max_hue - min_hue) * value_percent
	progress_bar.self_modulate = Color.from_hsv(hue, saturation, lightness_value, alpha)
