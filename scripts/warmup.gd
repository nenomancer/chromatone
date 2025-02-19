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

func on_warmup_guess(button: Button) -> void:
	var note = button.get_meta("note")
	GameManager.play_note(note, GameManager.SOUNDS.ANSWER)
	_buttons.disable_buttons()

	if (GameManager.current_note == note):
		GameManager.add_discovered_note(note)
		GameManager.show_notification_popup(button)
		GameManager.assign_warmup_notes()
	
	end_round()

func end_warmup() -> void:
	get_tree().change_scene_to_file(GameManager.DIALOGUE)

func start_round() -> void:
	_buttons.assign_color_to_buttons(func(note): return note in GameManager.warmup_notes)
	
	var other_notes = GameManager.warmup_notes.filter(func(note): return note not in GameManager.discovered_notes)
	GameManager.current_note = GameManager.get_random_note(other_notes)
	await get_tree().create_timer(1).timeout
	
	GameManager.play_note(GameManager.current_note, GameManager.SOUNDS.CALL)
	await get_tree().create_timer(1).timeout
	
	_buttons.enable_warmup_buttons()

func end_round() -> void:
	await get_tree().create_timer(2).timeout
	if (GameManager.discovered_notes.size() == 3):
		return end_warmup()
	
	if (GameManager.current_round < 5):
		GameManager.set_round(GameManager.current_round + 1)
		start_round()
	else:
		end_warmup()
	
