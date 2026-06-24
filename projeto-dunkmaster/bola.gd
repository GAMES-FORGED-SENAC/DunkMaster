extends RigidBody2D

@onready var area_de_colisao := $Area2D
@onready var animation_player := $AnimationPlayer


func _ready():
	area_de_colisao.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group("chao"):
		linear_velocity.y = -abs(linear_velocity.y) * 0.8
	elif body.is_in_group("parede"):
		linear_velocity.x = -linear_velocity.x * 0.8

func _physics_process(delta: float) -> void:
	if Global.dono_bola and Global.dono_bola.segurando_bola and Global.dono_bola.is_on_floor():
		animation_player.play("quicar")
	else:
		animation_player.stop()
		
