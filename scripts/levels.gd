extends Control

signal player_guess(is_correct)
@export var level_number: int

var _max_round: int = 5
var _max_level: int = 5
var _correct_melody: Array
var _player_melody: Array
var guess_index: int

var buttons: Control
var temp_score: int = 0
var _melody_stepsize: int = 1

func _ready():
	#load_buttons()
	GameManager.load_buttons()
	GameManager.buttons.note_selected.connect(on_level_guess)

	start_round()
	
	
func on_level_guess(note) -> void:
	GameManager.play_note(note)
	_player_melody.append(note)
	var correct_note = _correct_melody[guess_index]
	
	if note == correct_note: # Correct
		GameManager.update_score(10)
	else:
		GameManager.update_score(-5)
	
	guess_index += 1
	
	if (guess_index >= _correct_melody.size()):
		end_round()
		process_next_round()

func get_melody() -> void:
	_correct_melody = GameManager.get_melody()

func play_melody() -> void:
	for note in _correct_melody:
		GameManager.play_note(note)
		await get_tree().create_timer(_melody_stepsize).timeout

	#for index in range(_correct_melody.size()):
		#GameManager.play_note(_correct_melody[index])
		#await get_tree().create_timer(_melody_stepsize).timeout

func start_round() -> void:
	if (GameManager.current_round == 3):
		var random_note = GameManager.get_random_note(GameManager.get_undiscovered_notes())
		GameManager.add_discovered_note(random_note)

	guess_index = 0

	get_melody()
	await get_tree().create_timer(2).timeout
	play_melody()

	await get_tree().create_timer(2).timeout
	GameManager.enable_buttons()
	GameManager.buttons.assign_color_to_buttons(func(note): return note in GameManager.get_discovered_notes())

func process_next_round() -> void:
	if (GameManager.current_round < 5):
		GameManager.set_round(GameManager.current_round + 1)
		start_round()
	else: 
		GameManager.set_round(1)
		GameManager.set_level(GameManager.current_level + 1)
		# This should eventually be changed to open the Dialogue Scene
		GameManager.change_scene(GameManager.LEVELS)

func end_round() -> void:
	GameManager.enable_buttons(false)
	GameManager.buttons.clear_color_from_buttons()
	#GameManager.set_score(temp_score)
	await get_tree().create_timer(2).timeout
