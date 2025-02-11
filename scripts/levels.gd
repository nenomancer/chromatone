extends Control

@export var _max_round: int = 5
@export var _discovery_round: int = 4 # Think about this

var _correct_melody: Array
var _player_melody: Array
var _guess_index: int

var _buttons: Control
var _info: Control
var _melody_stepsize: int = 1

func _ready():
	load_info()
	load_buttons()
	GameManager.set_level(GameManager.current_level + 1)
	GameManager.set_round(1)
	start_round()

func load_buttons() -> void:
	_buttons = GameManager.BUTTONS.instantiate()
	add_child(_buttons)
	_buttons.note_selected.connect(on_level_guess)
	_buttons.disable_buttons()

func load_info() -> void:
	_info = GameManager.INFO.instantiate()
	add_child(_info)

func on_level_guess(note) -> void:
	GameManager.play_note(note)
	_player_melody.append(note)
	
	if note == _correct_melody[_guess_index]:
		GameManager.update_score(10)
	else:
		GameManager.update_score(-5)
	_guess_index += 1
	
	if (_guess_index < _correct_melody.size()):
		return

	end_round()
	
	if (GameManager.current_round < _max_round):
		GameManager.set_round(GameManager.current_round + 1)
		start_round()
	else: 
		GameManager.set_round(1)
		get_tree().change_scene_to_file(GameManager.DIALOGUE)
	
func get_melody() -> void:
	_correct_melody = GameManager.get_melody()

func play_melody() -> void:
	for index in range(_correct_melody.size()):
		GameManager.play_note(_correct_melody[index])
		await get_tree().create_timer(_melody_stepsize).timeout

func start_round() -> void:
	if (GameManager.current_round == _discovery_round):
		var random_note = GameManager.get_random_note(GameManager.get_undiscovered_notes())
		GameManager.add_discovered_note(random_note)

	_guess_index = 0

	await get_tree().create_timer(2).timeout
	get_melody()
	play_melody()

	await get_tree().create_timer(2).timeout
	_buttons.enable_buttons()
	_buttons.assign_color_to_buttons(func(note): return note in GameManager.discovered_notes)

func end_round() -> void:
	_buttons.disable_buttons()
	_buttons.clear_color_from_buttons()
	await get_tree().create_timer(2).timeout
