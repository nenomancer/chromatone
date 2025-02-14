extends Control

signal guess_selected(is_correct: bool)

@export var _max_round: int = 5
@export var _discovery_round: int = 4 # Think about this

var _correct_melody: Array
var _player_melody: Array
var _guess_index: int

var _buttons: Control
var _info: Control
var _guess_counter: HBoxContainer

var _melody_stepsize: int = 1

func _ready():
	load_info()
	load_buttons()
	load_guess_counter()
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
func load_guess_counter() -> void:
	_guess_counter = GameManager.GUESS_COUNTER.instantiate()
	add_child(_guess_counter)
	
func on_level_guess(note) -> void:
	GameManager.play_note(note, GameManager.SOUNDS.ANSWER)
	_player_melody.append(note)
	
	if note == _correct_melody[_guess_index]:
		GameManager.update_score(10)
		emit_signal("guess_selected", true)
	else:
		GameManager.update_score(-5)
		emit_signal("guess_selected", false)
	_guess_index += 1
	
	if (_guess_index < _correct_melody.size()):
		return
		
	end_round()
	
	if (GameManager.current_round < _max_round):
		GameManager.set_round(GameManager.current_round + 1)
		start_round()
	else: 
		await get_tree().create_timer(2).timeout
		GameManager.set_round(1)
		get_tree().change_scene_to_file(GameManager.DIALOGUE)
	
func get_melody() -> void:
	_correct_melody = GameManager.get_melody()

func play_melody() -> void:
	for index in range(_correct_melody.size()):
		GameManager.play_note(_correct_melody[index], GameManager.SOUNDS.CALL)
		await get_tree().create_timer(_melody_stepsize).timeout

func start_round() -> void:
	if (GameManager.current_round == _discovery_round):
		var random_note = GameManager.get_random_note(GameManager.get_undiscovered_notes())
		GameManager.add_discovered_note(random_note)

	_guess_index = 0

	await get_tree().create_timer(2).timeout
	_guess_counter.generate_guess_counts()
	get_melody()
	play_melody()

	await get_tree().create_timer(2).timeout
	_buttons.assign_color_to_buttons(func(note): return note in GameManager.discovered_notes)
	_buttons.enable_discovered_buttons()

func end_round() -> void:
	_buttons.disable_buttons()
	await get_tree().create_timer(2).timeout
	_guess_counter.clear_colors()
	_buttons.clear_color_from_buttons()
