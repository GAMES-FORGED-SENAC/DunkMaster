extends StaticBody2D

var foi_ponto = false
var pontos = 0
func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bola"):
		pontos += 1
		foi_ponto = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("bola"):
		foi_ponto = false
