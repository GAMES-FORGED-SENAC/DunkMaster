extends CharacterBody2D

@onready var animacoes = $AnimatedSprite2D
const SPEED = 300.0
const JUMP_VELOCITY = -600
var is_jumping= false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.5
	movimentar_vertical()
	movimentar_horizontal()
	Mudar_animacoes()
	move_and_slide()





func movimentar_vertical():
	if is_jumping and is_on_floor():
		is_jumping=false
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping= true
		animacoes.play("jump")

func movimentar_horizontal():
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction == 1:
			animacoes.flip_h = false
		elif direction == -1:
			animacoes.flip_h = true
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

func Mudar_animacoes():
	if is_jumping == false:
		if velocity.x == 0:
			animacoes.play("default")
		elif velocity.x != 0:
			animacoes.play("run")
