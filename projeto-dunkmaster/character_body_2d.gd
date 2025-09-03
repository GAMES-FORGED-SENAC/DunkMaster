extends CharacterBody2D

@onready var personagem = $"."
@onready var animacoes = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -600

var offset_x = 0
var is_jumping = false
var bola_colidida: Node2D = null
var segurando_bola = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.5

	movimentar_vertical()
	movimentar_horizontal()
	Mudar_animacoes()
	move_and_slide()

	# Pegar bola
	if bola_colidida and Input.is_action_just_pressed("driblaEpega"):
		segurando_bola = true

	# Atualizar posição da bola se estiver segurando
	if segurando_bola and bola_colidida:
		var offset_x = 50
		if animacoes.flip_h:
			offset_x = -50

		var offset = Vector2(offset_x, 0)
		bola_colidida.global_position = personagem.global_position + offset

func movimentar_vertical():
	if is_jumping and is_on_floor():
		is_jumping = false
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		animacoes.play("jump")

func movimentar_horizontal():
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animacoes.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func Mudar_animacoes():
	if not is_jumping:
		if velocity.x == 0:
			animacoes.play("default")
		else:
			animacoes.play("run")

func _on_frente_body_entered(body: Node2D) -> void:
	if body.is_in_group("bola"):
		bola_colidida = body
