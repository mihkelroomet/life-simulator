# Player movement set up with the help of this tutorial: https://www.youtube.com/watch?v=uNReb-MHsbg

extends CharacterBody2D

const ACCELERATION = 2000
const FRICTION = 2000
const MAX_SPEED = 300

enum {IDLE, MOVE}
var state = IDLE

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]

var blend_position : Vector2 = Vector2(0, 1) # look down at start
var blend_pos_paths = [
	"parameters/idle/idle_bs2d/blend_position",
	"parameters/move/move_bs2d/blend_position",
]
var animation_tree_state_keys = [
	"idle",
	"move"
]

func _physics_process(delta):
	if Globals.player_can_move:
		move(delta)
		animate()

func move(delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_vector == Vector2.ZERO:
		state = IDLE
		apply_friction(FRICTION * delta)
	else:
		state = MOVE
		apply_movement(input_vector * ACCELERATION * delta)
		blend_position = input_vector
	
	move_and_slide()

func apply_friction(amount) -> void:
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func apply_movement(amount) -> void:
	velocity += amount
	velocity = velocity.limit_length(MAX_SPEED)

func animate() -> void:
	state_machine.travel(animation_tree_state_keys[state])
	animation_tree.set(blend_pos_paths[state], blend_position)
