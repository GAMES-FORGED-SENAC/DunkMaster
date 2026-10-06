extends Node
var dono_bola: Node2D = null
var posicaoJogador = null


var GLOBALjogador_1 = ""
var GLOBALjogador2 = ""

func _physics_process(delta: float) -> void:
	if GLOBALjogador_1 == "":
		GLOBALjogador_1 = "Jogador 1"
	if GLOBALjogador2 == "":
		GLOBALjogador2 = "Jogador 2"
