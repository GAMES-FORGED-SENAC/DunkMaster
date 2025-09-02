extends RigidBody2D

const SPEED = 300.0
var JUMP_VELOCITY = -400.0
@onready var raycast_down = $RayCastbaixo
@onready var raycast_esquerda = $RayCastesquerda
@onready var raycast_direita = $RayCastdireita

func _physics_process(delta: float) -> void:
	# Aplicar gravidade manual, se necessário
	if not raycast_down.is_colliding():
		linear_velocity.y += 400 * delta
	
	if Input.is_action_just_pressed("bola_quicar"):
		JUMP_VELOCITY = -400.0
		linear_velocity.y = JUMP_VELOCITY
	
	# Rebater ao tocar na parede
	if raycast_direita.is_colliding():
		linear_velocity.x = -linear_velocity.x
	
	if raycast_esquerda.is_colliding():
		linear_velocity.x = -linear_velocity.x
		
	if raycast_down.is_colliding():
		linear_velocity.y = JUMP_VELOCITY
		
#func quicar_nochao(body: Node2D) -> void:
	#if raycast_down.is_colliding():
	#if JUMP_VELOCITY < 0:
		#JUMP_VELOCITY += 40  # Reduz a força do próximo salto
	#linear_velocity.y = JUMP_VELOCITY
	#print(JUMP_VELOCITY)
	#print(body)
	
