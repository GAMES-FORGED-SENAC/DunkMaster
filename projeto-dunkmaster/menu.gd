extends Node2D

func _physics_process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://escolha_personagem.tscn")


func _on_options1_pressed() -> void:
	get_tree().change_scene_to_file("res://options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits1_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")
