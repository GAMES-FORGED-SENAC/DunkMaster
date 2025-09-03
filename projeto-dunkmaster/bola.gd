extends RigidBody2D

const GRAVITY = 400.0
const BOUNCE_FORCE_VERTICAL = -500.0
const BOUNCE_FORCE_HORIZONTAL = 300.0

@onready var area_de_colisao = $Area2D

func _ready():
	# Conectar sinal para detectar entrada de corpo na área
	area_de_colisao.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	# Aplicar gravidade manualmente
	linear_velocity.y += GRAVITY * delta

func _on_body_entered(body):
	if body.is_in_group("chao"):
		# Quicar pra cima
		linear_velocity.y = BOUNCE_FORCE_VERTICAL

	elif body.is_in_group("parede"):
		# Quicar pro lado oposto ao movimento atual
		if linear_velocity.x > 0:
			linear_velocity.x = -BOUNCE_FORCE_HORIZONTAL
		else:
			linear_velocity.x = BOUNCE_FORCE_HORIZONTAL
