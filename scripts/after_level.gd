extends Control

@export var discovered_notes_display: HBoxContainer
@export var next_level_button: Button

func _ready() -> void:
	next_level_button.pressed.connect(_start_next_level)
	next_level_button.text = 'Start Level ' + var_to_str(GameManager.current_level + 1)
	var placeholder: String
	if (GameManager.current_level == 0):
		placeholder = 'the warmup round'
	else:
		placeholder = 'level ' + var_to_str(GameManager.current_round)
	
	var discovered_notes_size = var_to_str(GameManager.discovered_notes.size())
	var score = var_to_str(GameManager.current_score)
	$VBoxContainer/Info2.text = 'You passed ' + placeholder + \
	', scored ' + score + \
	' points and discovered ' + discovered_notes_size + ' notes!'
	load_buttons()

func _start_next_level() -> void:
	get_tree().change_scene_to_file(GameManager.LEVELS)

func load_buttons() -> void:
	var buttons_ui = GameManager.BUTTONS.instantiate()
	add_child(buttons_ui)
	buttons_ui.note_selected.connect(on_dialogue_press)
	buttons_ui.assign_color_to_buttons(func(note): return note in GameManager.discovered_notes, false)
	buttons_ui.enable_discovered_buttons()
	
func on_dialogue_press(button: Button) -> void:
	var note = button.get_meta("note")
	GameManager.play_note(note, GameManager.SOUNDS.ANSWER)
