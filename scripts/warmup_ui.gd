extends Control

var _correct_note: String
var buttons_ui: Node
var _correct_guesses: int = 0
var _score: int = 0

func _ready():
	buttons_ui = load("res://scenes/buttons_ui.tscn").instantiate()
	$UI.add_child(buttons_ui)
	
	buttons_ui.note_selected.connect(on_warmup_guess)
	start_round()

func on_warmup_guess(note) -> void:
	GameManager.play_note(note)
	buttons_ui.disable_buttons()

	if (_correct_note == note || GameManager.current_round - GameManager.discovered_notes.size() >= 3):
		GameManager.add_discovered_note(note)
		_correct_guesses += 1
	
	end_round()

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file(GameManager.LEVELS_UI)
	

func start_level_1() -> void:
	GameManager.set_level(1)
	GameManager.set_round(1)
	get_tree().change_scene_to_file(GameManager.LEVELS_UI)

func start_round() -> void:
	buttons_ui.assign_color_to_buttons(func(note): return note in GameManager.available_notes)
	_correct_note = GameManager.get_random_note(GameManager.get_undiscovered_notes())
	#await get_tree().create_timer(1).timeout # See what's the problem here
	GameManager.play_note(_correct_note)
	#await get_tree().create_timer(1).timeout
	buttons_ui.enable_some_buttons()

func end_round() -> void:
	await get_tree().create_timer(2).timeout
	if (GameManager.discovered_notes.size() == 3):
		return start_level_1()
	
	if (GameManager.current_round < 5):
		GameManager.set_round(GameManager.current_round + 1)
		start_round()
	else:
		start_level_1()
	
