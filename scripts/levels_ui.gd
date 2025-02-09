extends Control

signal note_discovered

@export var level_number: int

var _max_round: int = 5
var _max_level: int = 5
var _correct_melody: Array
var _player_melody: Array
var guess_index: int

var buttons_ui: Control
var info_ui: Control
var temp_score: int = 0
var _melody_stepsize: int = 1

func _ready():
	load_info()
	load_buttons()
	GameManager.set_round(1)
	GameManager.set_level(GameManager.current_level + 1)
	start_round()
	
func on_level_guess(note) -> void:
	GameManager.play_note(note)
	_player_melody.append(note)
	
	if note == _correct_melody[guess_index]:
		temp_score += 10
	else:
		temp_score -= 5
	guess_index += 1
	
	if (guess_index < _correct_melody.size()):
		return

	end_round()
	
	if (GameManager.current_round < 5):
		GameManager.set_round(GameManager.current_round + 1)
		start_round()
	else: 
		GameManager.set_round(1)
		GameManager.set_level(GameManager.current_level + 1)
		# This should eventually be changed to open the Dialogue Scene
		get_tree().change_scene_to_file(GameManager.LEVELS_UI)
	
func get_melody() -> void:
	_correct_melody = GameManager.get_melody()

func play_melody() -> void:
	for index in range(_correct_melody.size()):
		GameManager.play_note(_correct_melody[index])
		await get_tree().create_timer(_melody_stepsize).timeout
	
func load_buttons() -> void:
	buttons_ui = GameManager.BUTTONS_UI.instantiate()
	add_child(buttons_ui)
	buttons_ui.note_selected.connect(on_level_guess)
	buttons_ui.disable_buttons()

func load_info() -> void:
	info_ui = GameManager.INFO.instantiate()
	add_child(info_ui)
	connect('note_discovered', info_ui.update_discovered_notes)
	emit_signal("note_discovered")

func start_round() -> void:
	if (GameManager.current_round == 3):
		var random_note = GameManager.get_random_note(GameManager.get_undiscovered_notes())
		GameManager.add_discovered_note(random_note)
		emit_signal("note_discovered")

	guess_index = 0

	await get_tree().create_timer(2).timeout
	get_melody()
	play_melody()

	await get_tree().create_timer(2).timeout
	buttons_ui.enable_buttons()
	buttons_ui.assign_color_to_buttons(func(note): return note in GameManager.get_discovered_notes())

func end_round() -> void:
	buttons_ui.disable_buttons()
	buttons_ui.clear_color_from_buttons()
	GameManager.set_score(temp_score)
	await get_tree().create_timer(2).timeout
