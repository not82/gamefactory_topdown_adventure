extends CharacterBody2D

@export_category("Stats")
@export var baseSpeed:float = 400	# En velocity par seconde

#@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var animationTree : AnimationTree = $AnimationTree
@onready var animationPlayback : AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

enum State {
	IDLE,
	WALK
}

var state : State = State.IDLE

#func _process(delta: float) -> void:
func _process(delta: float) -> void:
	var move = Vector2.ZERO

#	Inputs
	if Input.is_action_pressed("right"):
		move.x += baseSpeed
	if Input.is_action_pressed("left"):
		move.x -= baseSpeed
	if Input.is_action_pressed("up"):
		move.y -= baseSpeed
	if Input.is_action_pressed("down"):
		move.y += baseSpeed

# Animations
	if move == Vector2.ZERO && state == State.WALK:
		state = State.IDLE
		updateAnimation()
	elif move != Vector2.ZERO && state == State.IDLE:
		state = State.WALK
		updateAnimation()

	if move.x < -0.01:
		sprite.flip_h = true
	elif move.x > 0.01:
		sprite.flip_h = false
		
	set_velocity(move)	
	move_and_slide()

func updateAnimation() -> void:
	match state:
		State.IDLE:
			animationPlayback.travel("idle")
		State.WALK:
			animationPlayback.travel("walk")
