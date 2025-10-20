extends CharacterBody2D

# === NÓS ===
@onready var personagem = $"."
@onready var animacoes = $AnimatedSprite2D
@onready var area_colision = $frente/CollisionShape2D

# === CONSTANTES ===
const SPEED = 300.0
const JUMP_VELOCITY = -600

# === VARIÁVEIS ===
var is_jumping = false
var bola_colidida: RigidBody2D = null
var segurando_bola = false

# === PROCESSO PRINCIPAL ===
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.5

	movimentar_vertical()
	movimentar_horizontal()
	mudar_animacoes()
	move_and_slide()

	# Um único comando para pegar ou jogar a bola
	if Input.is_action_just_pressed("jogaEpega"):
		if segurando_bola:
			jogar_bola()
		else:
			pegar_bola()

	# Atualizar posição da bola se estiver segurando
	if segurando_bola and bola_colidida:
		atualizar_posicao_bola()

# === MOVIMENTAÇÃO ===
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
		if direction == -1:
			area_colision.position.x = -48
		elif direction == 1:
			area_colision.position.x = 48
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

# === ANIMAÇÕES ===
func mudar_animacoes():
	if not is_jumping:
		if velocity.x == 0:
			animacoes.play("default")
		else:
			animacoes.play("run")

# === COLISÃO COM A BOLA ===
func _on_frente_body_entered(body: Node2D) -> void:
	if body.is_in_group("bola") and body is RigidBody2D:
		bola_colidida = body

func _on_frente_body_exited(body: Node2D) -> void:
	if body == bola_colidida:
		bola_colidida = null


# === PEGAR BOLA ===
func pegar_bola():
	if bola_colidida:
		segurando_bola = true
		bola_colidida.freeze = true  # Congela física enquanto segura

# === ATUALIZA POSIÇÃO DA BOLA JUNTO AO PERSONAGEM ===
func atualizar_posicao_bola():
	var offset_x = 60
	if animacoes.flip_h:
		offset_x = -60
	var offset = Vector2(offset_x, 0)
	bola_colidida.global_position = personagem.global_position + offset

# === JOGAR / SOLTAR BOLA ===
func jogar_bola():
	if segurando_bola and bola_colidida:
		segurando_bola = false
		bola_colidida.freeze = false  # Descongela física
		bola_colidida.linear_velocity = Vector2.ZERO  # Zera a velocidade atual

		# Define a força do arremesso
		var direcao = animacoes.flip_h if animacoes else false
		var forca = Vector2(600, -200)  # Ajuste conforme necessário

		if direcao:
			forca.x *= -1

		# Aplica o impulso à bola
		bola_colidida.apply_central_impulse(forca)
