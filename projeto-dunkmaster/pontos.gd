extends Node2D

@onready var mensagens: Label = $Panel/Mensagens
@onready var pause = $CanvasLayer/Panel
@onready var cesta1 = $cesta1/cesta #Cena exporta base cesta e qdentro da base tem a exportata cesta
@onready var cesta2 = $cesta2/cesta #Cena exporta base cesta e qdentro da base tem a exportata cesta
@onready var pontoj1 = $Panel/pontos_j1
@onready var pontoj2 = $Panel/pontos_j2
@onready var label_cronometro: Label = $Panel/Panel/LabelCronometro
@onready var timer_cronometro: Timer = $Panel/Panel/Timer
@onready var timer_ponto_e_final: Timer = $Panel/Mensagens/TimerPontoEFinal

var pontos1 = 0
var pontos2 = 0

func _ready() -> void:
	mensagens.visible = false
	timer_cronometro.timeout.connect(acabar)
	timer_ponto_e_final.timeout.connect(voltar_ao_menu)
	
func _process(delta: float) -> void:
	label_cronometro.text = str(round(timer_cronometro.time_left))
	
	
	
	
	if is_instance_valid(cesta1) and cesta1.foi_ponto == true:
		pontos1 += 2
		pontoj1.text = str(pontos1)
		cesta1.foi_ponto = false
		
	if is_instance_valid(cesta2) and cesta2.foi_ponto == true:
		pontos2 += 2
		pontoj2.text = str(pontos2)
		cesta2.foi_ponto = false

func acabar() -> void:
	if pontos1 > pontos2:
		mensagens.text = "O jogador 1 ganhou a partida!"
	elif pontos2 > pontos1:
		mensagens.text = "O jogador 2 ganhou a partida!"
	else:
		mensagens.text = "A partida acabou em empate!"
	mensagens.visible = true
	timer_ponto_e_final.start()  # Inicia o timer que leva de volta ao menu

func voltar_ao_menu() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
