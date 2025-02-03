extends Control

@export var level_number: int

var _current_round = GameManager.get_round()
var _current_level = GameManager.get_level()
var _correct_note: String

func _ready():
	_correct_note = GameManager.get_random_note()
	
	var buttons_ui = load("res://buttons_ui/buttons_ui.tscn").instantiate()
	$UI.add_child(buttons_ui)
	buttons_ui.assign_color_to_buttons(func(note, i): return note in GameManager.get_discovered_notes())
	buttons_ui.note_selected.connect(on_level_guess)
	
func on_level_guess(note):
	GameManager.play_note(note)
	if (note == _correct_note):
		print("CORRECT!")
	else:
		print("Incorrect!")
	print("guessed note: ", note, ' correct note was: ', _correct_note)
	$InfoLabel.text = "Current round: " + var_to_str(GameManager.get_round()) + " Current Level: " + var_to_str(GameManager.get_level())
	
	await get_tree().create_timer(2).timeout
	if (_current_round < 5):
		GameManager.set_round(_current_round + 1)
	else: 
		GameManager.set_round(1)
		GameManager.set_level(_current_level + 1)
	
	get_tree().change_scene_to_file(GameManager.LEVELS_UI)
	
	

func _on_button_pressed() -> void:
	GameManager.set_round(GameManager.get_round() + 1)
	get_tree().change_scene_to_file(GameManager.MAIN)


func _on_button_2_pressed() -> void:
	GameManager.set_round(GameManager.get_round() + 1)
	get_tree().change_scene_to_file(GameManager.WARMUP_UI)
	
