extends CharacterBody2D

# === NÓS ===
@onready var personagem = $"."
@onready var animacoes = $AnimatedSprite2D
@onready var area_colision = $frente/CollisionShape2D

# AJUSTE APENAS O CAMINHO DA SUA BARRA
@onready var power_bar = $ProgressBar


# === CONSTANTES ===
var SPEED = 300.0
var JUMP_VELOCITY = -555

# === VARIÁVEIS ===
var is_jumping = false
var bola_colidida: RigidBody2D = null
var segurando_bola = false
var atordoado = false

# === SISTEMA DA BARRA DE ARREMESSO ===
var carregando_arremesso = false
var forca_barra = 0.0
var aumentando = true

const FORCA_MIN = 250.0
const FORCA_MAX = 475.0
const VELOCIDADE_BARRA = 150.0
func _ready() -> void:
	power_bar.visible = false
	
# === PROCESSO PRINCIPAL ===
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.5

	$Nick_p2.text = Global.GLOBALjogador2

	movimentar_vertical()
	movimentar_horizontal()
	mudar_animacoes()
	atualizar_barra(delta)

	move_and_slide()

	acao_bola()


# === MOVIMENTAÇÃO ===
func movimentar_vertical():
	if is_jumping and is_on_floor():
		is_jumping = false

	if Input.is_action_just_pressed("pulaP2") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		animacoes.play("jump")


func movimentar_horizontal():
	var direction := Input.get_axis("esquerdaP2", "direitaP2")

	if direction:
		velocity.x = direction * SPEED
		animacoes.flip_h = direction < 0
		area_colision.position.x = 48 * direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


# === ANIMAÇÕES ===
func mudar_animacoes():
	if not is_jumping:
		if velocity.x == 0:
			animacoes.play("default")
		else:
			animacoes.play("run")


# === BARRA DE FORÇA ===
func atualizar_barra(delta):
	if !carregando_arremesso:
		return

	if aumentando:
		forca_barra += VELOCIDADE_BARRA * delta

		if forca_barra >= 100:
			forca_barra = 100
			aumentando = false


	power_bar.value = forca_barra


# === AÇÕES COM A BOLA ===
func acao_bola():
	if atordoado:
		return

	if Input.is_action_just_pressed("pegaP2"):
		if segurando_bola:
			soltar_bola()
		else:
			pegar_bola()

	if segurando_bola:

		if Input.is_action_just_pressed("jogaP2"):
			carregando_arremesso = true
			forca_barra = 0
			aumentando = true
			power_bar.visible = true

		if Input.is_action_just_released("jogaP2"):
			carregando_arremesso = false
			power_bar.visible = false
			tacar_bola()

	if segurando_bola and bola_colidida:
		atualizar_posicao_bola()


# === PEGAR BOLA ===
func pegar_bola():
	if bola_colidida:
		if Global.dono_bola == null:
			bola_colidida.rotation = 0
			segurando_bola = true
			Global.dono_bola = self
			bola_colidida.freeze = true
			bola_colidida.linear_velocity = Vector2.ZERO
			bola_colidida.angular_velocity = 0

		elif Global.dono_bola != null and Global.dono_bola != self:
			Global.dono_bola.soltar_bola()

			bola_colidida.rotation = 0
			segurando_bola = true
			Global.dono_bola = self
			bola_colidida.freeze = true
			bola_colidida.linear_velocity = Vector2.ZERO
			bola_colidida.angular_velocity = 0

	else:
		$AudioStreamPlayer2D.play()
		atordoado = true
		SPEED = 0
		JUMP_VELOCITY = 0
		await get_tree().create_timer(0.7).timeout
		atordoado = false
		SPEED = 300.0
		JUMP_VELOCITY = -555


# === SOLTAR BOLA ===
func soltar_bola():
	if segurando_bola and bola_colidida:
		segurando_bola = false
		Global.dono_bola = null
		bola_colidida.freeze = false
		bola_colidida.sleeping = false
		bola_colidida.linear_velocity = Vector2.ZERO

		carregando_arremesso = false
		power_bar.visible = false


# === TACAR BOLA ===
func tacar_bola():
	if segurando_bola and bola_colidida:

		Global.posicaoJogador = global_position.x

		Global.dono_bola = null
		segurando_bola = false

		bola_colidida.freeze = false
		bola_colidida.sleeping = false
		bola_colidida.linear_velocity = Vector2.ZERO
		bola_colidida.angular_velocity = 0

		var direcao_x = -1 if animacoes.flip_h else 1

		var intensidade = lerp(FORCA_MIN, FORCA_MAX, forca_barra / 100.0)

		var forca = Vector2(
			intensidade * direcao_x,
			-intensidade * 1.5
		)

		bola_colidida.apply_central_impulse(forca)


# === ATUALIZA POSIÇÃO DA BOLA ===
func atualizar_posicao_bola():
	var offset_x = 60 if !animacoes.flip_h else -60
	var offset = Vector2(offset_x, -10)

	bola_colidida.global_position = personagem.global_position + offset


# === COLISÃO COM A BOLA ===
func _on_frente_body_entered(body: Node2D) -> void:
	if body.is_in_group("bola") and body is RigidBody2D:
		bola_colidida = body


func _on_frente_body_exited(body: Node2D) -> void:
	if body == bola_colidida and !segurando_bola:
		bola_colidida = null
