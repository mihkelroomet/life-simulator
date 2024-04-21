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

var last_value : float = -1.0 # -1 represents uninitialized value

func _process(delta):
	if last_value != -1.0:
		ping_arrows(delta)
	last_value = progress_bar.value

func ping_arrows(delta):
	var change = progress_bar.value - last_value
	var change_per_second = change / delta
	
	# If change is positive
	if change_per_second >= POSITIVE_THRESHOLD_0_1:
		right_arrow_1.ping()
		if change_per_second >= POSITIVE_THRESHOLD_1_2:
			right_arrow_2.ping()
			if change_per_second >= POSITIVE_THRESHOLD_2_3:
				right_arrow_3.ping()
	
	# If change is negative
	elif change_per_second <= NEGATIVE_THRESHOLD_0_1:
		left_arrow_1.ping()
		if change_per_second <= NEGATIVE_THRESHOLD_1_2:
			left_arrow_2.ping()
			if change_per_second <= NEGATIVE_THRESHOLD_2_3:
				left_arrow_3.ping()
