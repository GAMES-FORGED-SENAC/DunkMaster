extends Node2D
func _process(delta: float) -> void:
	Global.GLOBALjogador_1 = $PanelP1/TextEdit1.text
	Global.GLOBALjogador2 = $PanelP2/TextEdit2.text


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
