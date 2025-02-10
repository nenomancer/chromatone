extends Control

signal note_discovered
var _correct_note: String
var buttons_ui: Node
var info_ui
var _score: int = 0

func _ready():
	load_info()
	load_buttons()
	GameManager.set_round(1)
	GameManager.set_level(0)
	start_round()

func load_buttons() -> void:
	buttons_ui = GameManager.BUTTONS_UI.instantiate()
	add_child(buttons_ui)
	buttons_ui.note_selected.connect(on_warmup_guess)

func load_info() -> void:
	info_ui = GameManager.INFO.instantiate()
	#info_ui.connect("note_discovered", info_ui, Callable(info_ui, "add_discovered_note"))
	connect("note_discovered", info_ui.update_discovered_notes)
	add_child(info_ui)

func on_warmup_guess(note) -> void:
	GameManager.play_note(note)
	buttons_ui.disable_buttons()

	if (_correct_note == note || GameManager.current_round - GameManager.discovered_notes.size() >= 3):
		GameManager.add_discovered_note(note)
		emit_signal('note_discovered')
	
	end_round()

func end_warmup() -> void:
	get_tree().change_scene_to_file(GameManager.DIALOGUE)

func start_round() -> void:
	buttons_ui.assign_color_to_buttons(func(note): return note in GameManager.available_notes)
	_correct_note = GameManager.get_random_note(GameManager.get_undiscovered_notes())
	
	await get_tree().create_timer(1).timeout # See what's the problem here
	GameManager.play_note(_correct_note)
	
	await get_tree().create_timer(1).timeout
	buttons_ui.enable_some_buttons()

func end_round() -> void:
	await get_tree().create_timer(2).timeout
	if (GameManager.discovered_notes.size() == 3):
		return end_warmup()
	
	if (GameManager.current_round < 5):
		GameManager.set_round(GameManager.current_round + 1)
		start_round()
	else:
		end_warmup()
	
