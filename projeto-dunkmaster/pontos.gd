extends Node2D

@onready var cesta1 = $cesta
@onready var pontoj1 = $Panel/pontos_j1
var pontos1 = 0


func _ready() -> void:
	pass 
	


func _process(delta: float) -> void:
	if cesta1.foi_ponto == true :
		pontos1 +=1
		pontoj1.text = str(pontos1)
		
