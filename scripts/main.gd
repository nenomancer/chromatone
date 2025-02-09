extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file(GameManager.WARMUP)

func _on_about_button_pressed() -> void:
	print("Info about the game and whatnot")

func _on_exit_button_pressed() -> void:
	print("Exiting game...")
	get_tree().quit()
	
