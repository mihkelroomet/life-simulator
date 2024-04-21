extends HBoxContainer

@onready var progress_bar = $ProgressBar

@onready var left_arrow_1 : TextureRect = $LeftArrowHBox/LeftArrow1
@onready var left_arrow_2 : TextureRect = $LeftArrowHBox/LeftArrow2
@onready var left_arrow_3 : TextureRect = $LeftArrowHBox/LeftArrow3

@onready var right_arrow_1 : TextureRect = $RightArrowHBox/RightArrow1
@onready var right_arrow_2 : TextureRect = $RightArrowHBox/RightArrow2
@onready var right_arrow_3 : TextureRect = $RightArrowHBox/RightArrow3

const NEGATIVE_THRESHOLD_2_3 : float = -2.0
const NEGATIVE_THRESHOLD_1_2 : float = -1.0
const NEGATIVE_THRESHOLD_0_1 : float = -0.1
const POSITIVE_THRESHOLD_0_1 : float = 0.1
const POSITIVE_THRESHOLD_1_2 : float = 1.0
const POSITIVE_THRESHOLD_2_3 : float = 2.0

var arrows : Array[TextureRect]
## Length of the alpha pulse loop of the little arrows, in seconds.
var arrow_pulse_loop_length : float = 2.5
var arrow_max_alpha : float = 1.0
var arrow_min_alpha : float = 0.25

var last_value : float

func _ready():
	arrows = [left_arrow_3, left_arrow_2, left_arrow_1, right_arrow_1, right_arrow_2, right_arrow_3]

func _process(delta):
	pulse_arrows_alpha()
	hide_arrows_not_in_use(delta)
	last_value = progress_bar.value

func hide_arrows_not_in_use(delta):
	var change = progress_bar.value - last_value
	var change_per_second = change / delta
	
	# If change is positive
	if change_per_second >= POSITIVE_THRESHOLD_0_1:
		hide_arrow(left_arrow_1)
		hide_arrow(left_arrow_2)
		hide_arrow(left_arrow_3)
		
		if change_per_second < POSITIVE_THRESHOLD_2_3:
			hide_arrow(right_arrow_3)
			if change_per_second < POSITIVE_THRESHOLD_1_2:
				hide_arrow(right_arrow_2)
	
	# If change is negative or negligible
	else:
		hide_arrow(right_arrow_1)
		hide_arrow(right_arrow_2)
		hide_arrow(right_arrow_3)
		
		if change_per_second > NEGATIVE_THRESHOLD_2_3:
			hide_arrow(left_arrow_3)
			if change_per_second > NEGATIVE_THRESHOLD_1_2:
				hide_arrow(left_arrow_2)
				if change_per_second > NEGATIVE_THRESHOLD_0_1:
					hide_arrow(left_arrow_1)

func hide_arrow(arrow : TextureRect):
	arrow.self_modulate = Color.TRANSPARENT

func pulse_arrows_alpha():
	var alpha : float
	
	if Globals.current_activity == Globals.Activity.IDLE:
		var time_in_seconds = Time.get_ticks_msec() / 1000.0
		# The fractional part of this variable represents percentage of current loop traversed
		var where_we_are_in_sine_loop = time_in_seconds / arrow_pulse_loop_length
		var radians = where_we_are_in_sine_loop * 2.0 * PI
		var alpha_0_to_1 = (sin(radians) + 1.0) / 2.0
		alpha = alpha_0_to_1 * (arrow_max_alpha - arrow_min_alpha) + arrow_min_alpha
	# This is because the other activities go by so fast
	else:
		alpha = 1.0
		
	for arrow in arrows:
		arrow.self_modulate = Color.from_hsv(0.0, 0.0, 1.0, alpha)
