extends Node2D


func options_on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
