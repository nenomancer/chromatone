extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file(GameManager.WARMUP_UI)
