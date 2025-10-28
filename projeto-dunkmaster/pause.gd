extends CanvasLayer

var esta_pausado = false
@onready var painel_pause: Panel = $Panel

func _ready() -> void:
	painel_pause.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		if not esta_pausado:
			get_tree().paused = true
			esta_pausado = true
			painel_pause.visible = true
		else:
			get_tree().paused = false
			esta_pausado = false
			painel_pause.visible = false
