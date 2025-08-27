extends CharacterBody2D

const SPEED = 300.0
var JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("bola_quicar") and JUMP_VELOCITY > -360:
		JUMP_VELOCITY = -400.0
		velocity.y = JUMP_VELOCITY
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if JUMP_VELOCITY < 0:
		JUMP_VELOCITY += 40
	velocity.y = JUMP_VELOCITY
	print(JUMP_VELOCITY)
	print(body)
	

	
