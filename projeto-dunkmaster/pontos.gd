extends Node2D


@onready var player_1: CharacterBody2D = $Node2D/player1
@onready var player_2: CharacterBody2D = $Node2D/player2
@onready var bola: RigidBody2D = $CharacterBody2D2

@onready var cesta_sound: AudioStreamPlayer = $"Basketball-backboard-83558"

@onready var mensagens: Label = $Panel/Mensagemfinal
@onready var pause = $CanvasLayer
@onready var cesta1 = $cesta1/cesta
@onready var cesta2 = $cesta2/cesta
@onready var pontoj1 = $Panel/pontos_j1
@onready var pontoj2 = $Panel/pontos_j2
@onready var label_cronometro: Label = $Panel/Panel/LabelCronometro
@onready var timer_cronometro: Timer = $Panel/Panel/Timer
@onready var timer_ponto_e_final: Timer = $Panel/Mensagemfinal/TimerPontoEFinal
@onready var mensagemponto: Label = $Panel/mensagemponto

var pontos1 = 0
var pontos2 = 0

func _ready() -> void:
	mensagens.visible = false
	timer_cronometro.timeout.connect(acabar)
	timer_ponto_e_final.timeout.connect(voltar_ao_menu)



func _process(delta: float) -> void:
	label_cronometro.text = str(round(timer_cronometro.time_left))
	contagem_pontos()



func acabar() -> void:
	if pontos1 > pontos2:
		mensagens.text = "O " + Global.GLOBALjogador_1 + " ganhou a partida!"
	elif pontos2 > pontos1:
		mensagens.text = "O " + Global.GLOBALjogador2 + " jogador 2 ganhou a partida!"
	else:
		mensagens.text = "A partida acabou em empate!"
	mensagens.visible = true
	
	$TorcidaVitoria.play()
	timer_ponto_e_final.start()


func voltar_ao_menu() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func contagem_pontos() -> void:
	if is_instance_valid(cesta1) and cesta1.foi_ponto == true:
		resetar_posicoes()
		cesta_sound.play()
		var valor_ponto = 2
		if abs(cesta1.global_position.x-Global.posicaoJogador) > 432:
			valor_ponto = 3
		pontos1 += valor_ponto
		pontoj1.text = str(pontos1)
		cesta1.foi_ponto = false

	if is_instance_valid(cesta2) and cesta2.foi_ponto == true:
		resetar_posicoes()
		cesta_sound.play()
		var valor_ponto = 2
		if abs(cesta2.global_position.x-Global.posicaoJogador) > 432:
			valor_ponto = 3
		pontos2 += valor_ponto
		pontoj2.text = str(pontos2)
		cesta2.foi_ponto = false
		
		
		
func resetar_posicoes():
	player_1.global_position = Vector2(160.0, 432.0)
	player_2.global_position = Vector2(992.0, 432.0)
	bola.global_position = Vector2(576.0, 360.0)

	bola.set_deferred("global_position", Vector2(576.0, 360.0))
	bola.set_deferred("linear_velocity", Vector2.ZERO)
	bola.set_deferred("angular_velocity", 0.0)
	bola.set_deferred("sleeping", true)
	await get_tree().process_frame
	bola.sleeping = false

	
