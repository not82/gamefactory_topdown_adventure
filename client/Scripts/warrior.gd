extends CharacterBody2D

@export_category("Stats")
@export var baseSpeed:float = 400	# En velocity par seconde

@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

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

# Animationsd
	if move == Vector2.ZERO:
		animation.play("idle")	
	else:
		animation.play("walk")

	if move.x != 0:
		if move.x < 0:
			sprite.flip_h = true
		else :
			sprite.flip_h = false
		
	set_velocity(move)	
	move_and_slide()
