extends Node

signal player_guess(is_correct: bool)
signal show_about
signal exit_game
signal change_level(level_number)
signal change_round(level_round)

var available_notes: Array = ["C", "D", "E", "F", "G", "A", "B"]
var available_colors: Array = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.PURPLE, Color.ORANGE, Color.CYAN]

var discovered_notes: Array = []
var correct_note: String

var current_round: int = 1
var current_level: int = 1
var current_score: int = 0

var color_note_pairs: Dictionary = {}
var current_note: String
var _note_sound_map: Dictionary = {
	"C": preload("res://sounds/grand_piano_c.wav"),
	"D": preload("res://sounds/grand_piano_d.wav"),
	"E": preload("res://sounds/grand_piano_e.wav"),
	"F": preload("res://sounds/grand_piano_f.wav"),
	"G": preload("res://sounds/grand_piano_g.wav"),	
	"A": preload("res://sounds/grand_piano_a.wav"),
	"B": preload("res://sounds/grand_piano_b.wav")
}

var _note_audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
var buttons_ui: Control
var buttons_array: Array

var discovered_notes_display: GridContainer

const MAIN: String = "res://main/main.tscn"
const LEVELS_UI: String = "res://scenes/levels.tscn"
const WARMUP_UI: String = "res://scenes/warmup.tscn"
const LABELS_UI: String = "res://scenes/labels.tscn"
const BUTTONS_UI: String = "res://scenes/buttons.tscn"
const DISCOVERED_NOTE: String = "res://scenes/discovered_note.tscn"
const DISCOVERED_NOTES: String = "res://scenes/discovered_notes.tscn"

func _ready() -> void:
	await get_tree().process_frame
	generate_audio_player()
	randomize_pairs()
	#player_guess.connect(_on_player_guess)
	change_round.connect(_on_change_round)
	change_level.connect(_on_change_level)
	

func generate_audio_player() -> void:
	#await get_tree().process_frame
	get_tree().root.add_child(_note_audio_player)
	
func generate_labels() -> void:
	#await get_tree().process_frame
	var labels = load(LABELS_UI).instantiate()
	get_tree().root.add_child(labels)
func play_note(note) -> void:
	if _note_audio_player:
		_note_audio_player.stream = _note_sound_map[note]
		_note_audio_player.volume_db = -7.0
		#_note_audio_player.pitch_scale = 7
		_note_audio_player.play()

func get_random_note(_note_array) -> String:
	return _note_array.pick_random()

func add_discovered_note(note: String):
	var color = color_note_pairs[note]['color']
	discovered_notes.append(note)
	var discovered_note = load(DISCOVERED_NOTE).instantiate()
	discovered_note.color = color
	discovered_notes_display.add_child(discovered_note)
	
func get_discovered_notes() -> Array:
	return discovered_notes

func get_undiscovered_notes() -> Array:
	return available_notes.filter(func(element): return not discovered_notes.has(element))

func set_round(new_round: int):
	current_round = new_round

func set_level(new_level: int):
	current_level = new_level

func randomize_pairs() -> void:
	color_note_pairs.clear()
	
	var shuffled_notes = available_notes.duplicate()
	shuffled_notes.shuffle()
	
	var shuffled_colors = available_colors.duplicate()
	shuffled_colors.shuffle()
	
	for i in range(shuffled_colors.size()):
		var note = shuffled_notes[i]
		var color = shuffled_colors[i]
		
		color_note_pairs[note] = {
			"color": color,
			"sound": _note_sound_map[note]
		}

func get_melody() -> Array:
	var melody: Array
	var previous_note: String = ""
	for i in range(discovered_notes.size()):
		var note = discovered_notes.pick_random()
		while (note == previous_note):
			note = discovered_notes.pick_random()
		previous_note = note
		melody.append(note)
	return melody

func set_score(new_score: int):
	current_score = new_score

#func _on_player_guess(_is_correct: bool): # Unnecessary for now
	#print("Player guess!: ")
	#print(_is_correct)

func _on_change_round(_round_number: int):
	#current_round = _round_number
	current_round += 1

func _on_change_level(_level_number: int):
	current_level += 1
	get_tree().change_scene_to_file(LEVELS_UI)

func load_buttons() -> void:
	buttons_ui = load(BUTTONS_UI).instantiate()
	get_tree().root.add_child(buttons_ui)
	buttons_array = buttons_ui.get_children()
	buttons_ui.disable_buttons()

func start_warmup():
	#load_buttons()
	discovered_notes_display = load(DISCOVERED_NOTES).instantiate()
	get_tree().root.add_child(discovered_notes_display)
	buttons_ui.assign_color_to_buttons(func(note): return note in available_notes)
	correct_note = get_random_note(get_undiscovered_notes())
	play_note(correct_note)
	buttons_ui.enable_discovered_buttons()

func end_warmup():
	pass

	
func start_warmup_round():
	buttons_ui.assign_color_to_buttons(func(note): return note in GameManager.available_notes)
	correct_note = get_random_note(get_undiscovered_notes())
	await get_tree().create_timer(1).timeout
	play_note(correct_note)
	await get_tree().create_timer(1).timeout
	buttons_ui.enable_discovered_buttons()

func end_warmup_round() -> void:
	await get_tree().create_timer(2).timeout
	if (discovered_notes.size() == 3):
		#return start_level_1()
		pass
	
	if (current_round < 5):
		set_round(current_round + 1)
		start_warmup_round()
	else:
		load_level()

func load_level():
	set_level(1)
	set_round(1)
	get_tree().change_scene_to_file(LEVELS_UI)
	
func on_warmup_guess(note):
	play_note(note)
	var selected_button: Button = buttons_array.filter(func(button): return button.get_meta('note') == note).front()
	
	print(selected_button)
	var correct_button: Button = buttons_array.filter(func(button): return button.get_meta('note') == correct_note).front()
	
	if (correct_note == note || current_round - discovered_notes.size() >= 3):
		add_discovered_note(note)
		selected_button.modulate = Color.WHITE
		#print("correct! the button was")
		
	else:
		selected_button.modulate = Color.BLACK
		correct_button.modulate = Color.WHITE
		
	await get_tree().create_timer(2).timeout
	buttons_ui.disable_buttons()
	end_warmup_round()
