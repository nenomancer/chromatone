extends Control

@export var _current_round: int = GameManager.get_round()
var _correct_note: String


func _ready():
	
	var buttons_ui = load("res://buttons_ui/buttons_ui.tscn").instantiate()
	$UI.add_child(buttons_ui)
	
	buttons_ui.note_selected.connect(on_warmup_guess)
	buttons_ui.assign_color_to_buttons(func(note, i): return i < GameManager.available_notes.size())
	
	# Get remaining notes here perhaps?
	_correct_note = GameManager.get_random_note(GameManager.get_undiscovered_notes()) # Generate correct note
	await get_tree().create_timer(1).timeout
	GameManager.play_note(_correct_note)
	
func on_warmup_guess(note):
	print("warmup note is: ", note)
	GameManager.play_note(note)
	
	if (_correct_note == note || _current_round > 2):
		if (note not in GameManager.discovered_notes):
			GameManager.add_discovered_note(note)
		# Points and whatnot
	else:
		print("Wrong")
		# No points and whatnot
		
	await get_tree().create_timer(2).timeout
	
	if (_current_round < 5):
		GameManager.set_round(_current_round + 1)
		get_tree().change_scene_to_file(GameManager.WARMUP_UI)
	else:
		GameManager.set_level(1)
		GameManager.set_round(1)
		get_tree().change_scene_to_file(GameManager.LEVELS_UI)
	

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file(GameManager.LEVELS_UI)
	
