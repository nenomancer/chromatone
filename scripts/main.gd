extends Control

@export var start_button: Button
@export var about_button: Button
@export var exit_button: Button

func _ready() -> void:
	start_button.pressed.connect(_start_game)
	about_button.pressed.connect(_show_abobut)
	exit_button.pressed.connect(_exit_game)
	

func _start_game() -> void:
	get_tree().change_scene_to_file(GameManager.WARMUP)

func _show_abobut() -> void:
	print("Info about the game and whatnot")

func _exit_game() -> void:
	print("Exiting game...")
	get_tree().quit()
