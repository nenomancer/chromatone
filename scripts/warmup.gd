extends Control

var _buttons: Control
var _info: Control

func _ready():
	load_info()
	load_buttons()
	GameManager.set_round(1)
	GameManager.set_level(0)
	start_round()

func load_buttons() -> void:
	_buttons = GameManager.BUTTONS.instantiate()
	add_child(_buttons)
	_buttons.note_selected.connect(on_warmup_guess)
	_buttons.disable_buttons()

func load_info() -> void:
	_info = GameManager.INFO.instantiate()
	add_child(_info)

func on_warmup_guess(note) -> void:
	GameManager.play_note(note)
	_buttons.disable_buttons()

	if (GameManager.current_note == note || GameManager.current_round - GameManager.discovered_notes.size() >= 3):
		GameManager.add_discovered_note(note)
	
	end_round()

func end_warmup() -> void:
	get_tree().change_scene_to_file(GameManager.DIALOGUE)

func is_discovered(note):
	return note in GameManager.available_notes
	
func start_round() -> void:
	_buttons.assign_color_to_buttons(is_discovered)
	GameManager.current_note = GameManager.get_random_note(GameManager.get_undiscovered_notes())
	
	await get_tree().create_timer(1).timeout # See what's the problem here
	GameManager.play_note(GameManager.current_note)
	
	await get_tree().create_timer(1).timeout
	_buttons.enable_undiscovered_buttons()

func end_round() -> void:
	await get_tree().create_timer(2).timeout
	if (GameManager.discovered_notes.size() == 3):
		return end_warmup()
	
	if (GameManager.current_round < 5):
		GameManager.set_round(GameManager.current_round + 1)
		start_round()
	else:
		end_warmup()
	
