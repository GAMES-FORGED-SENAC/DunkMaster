extends RigidBody2D

@onready var area_de_colisao = $Area2D

func _ready():
	area_de_colisao.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("chao"):
		linear_velocity.y = -abs(linear_velocity.y) * 0.8
	elif body.is_in_group("parede"):
		linear_velocity.x = -linear_velocity.x * 0.8
