extends CharacterBody2D

@export_category("Stats")
@export var baseSpeed:float = 400	# En velocity par seconde
@export var attackSpeed:float = 0.6
@export var attack_damage:int = 60

#@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var animationTree : AnimationTree = $AnimationTree
@onready var animationPlayback : AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

enum State {
	IDLE,
	WALK,
	ATTACK
}

var state : State = State.IDLE

func _ready()->void:
	
	#$HitBox.monitoring = false
	print("Monitoring au ready:", $HitBox.monitoring)
	animationTree.set_active(true)
	

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
	
	if Input.is_action_just_pressed("attack"):
		attack(move)
		
	if state == State.ATTACK:
		return
		
	handleMove(move)

func handleMove(move) -> void:
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
		State.ATTACK:
			animationPlayback.travel("attack")

func attack(currentMove : Vector2) -> void:
	if state == State.ATTACK:
		return
	state = State.ATTACK
	
	
	var attackDir = currentMove.normalized()
	sprite.flip_h = attackDir.x < 0
	animationTree.set("parameters/attack/BlendSpace2D/blend_position", attackDir)
	updateAnimation()
	await get_tree().create_timer(attackSpeed).timeout
	state = State.IDLE
	updateAnimation()


func _on_hit_box_area_entered(area: Area2D) -> void:
	area.owner.take_damage(attack_damage)
