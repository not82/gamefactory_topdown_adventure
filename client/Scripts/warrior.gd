extends CharacterBody2D

@export var baseSpeed = 10000

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	velocity = Vector2()

#	Inputs
	if Input.is_action_pressed("right"):
		velocity.x = baseSpeed * delta
	if Input.is_action_pressed("left"):
		velocity.x = - baseSpeed * delta
	if Input.is_action_pressed("top"):
		velocity.y = -baseSpeed * delta
	if Input.is_action_pressed("down"):
		velocity.y = baseSpeed * delta

# Animations
	if velocity == Vector2.ZERO:
		animation.play("idle")	
	else:
		animation.play("walk_right")

	if velocity.x != 0:
		if velocity.x < 0:
			animation.flip_h = true
		else :
			animation.flip_h = false
		
	move_and_slide()
	
	
#func _physics_process(delta: float) -> void:
	#pass
