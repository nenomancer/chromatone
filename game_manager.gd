extends Node

var available_notes: Array = ["C", "D", "E", "F", "G", "A", "B"]
var available_colors: Array = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.PURPLE, Color.ORANGE, Color.CYAN]

var discovered_notes: Array = []
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

const LEVELS_UI: String = "res://levels_ui/levels_ui.tscn"
const WARMUP_UI: String = "res://warmup_ui/warmup_ui.tscn"
const MAIN: String = "res://main/main.tscn"

func _ready() -> void:
	generate_audio_player()
	randomize_pairs()

func generate_audio_player() -> void:
	await get_tree().process_frame
	get_tree().root.add_child(_note_audio_player)
	
func play_note(note) -> void:
	if _note_audio_player:
		_note_audio_player.stream = _note_sound_map[note]
		_note_audio_player.volume_db = -7.0
		#_note_audio_player.pitch_scale = 7
		_note_audio_player.play()


func get_random_note2(_all_notes: bool = false) -> String:
	if (_all_notes):
		return available_notes.pick_random()
	
	return discovered_notes.pick_random()

func get_random_note(_note_array) -> String:
	return _note_array.pick_random()

func add_discovered_note(note: String):
	discovered_notes.append(note)
	
func get_discovered_notes() -> Array:
	return discovered_notes

func get_undiscovered_notes() -> Array:
	return available_notes.filter(func(element): return not discovered_notes.has(element))

func set_round(new_round: int):
	current_round = new_round

func get_round() -> int:
	return current_round
	
func set_level(new_level: int):
	current_level = new_level
	
func get_level() -> int:
	return current_level

func get_color_note_pairs() -> Dictionary:
	return color_note_pairs

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

func get_score() -> int:
	return current_score
	
func set_score(new_score: int):
	current_score = new_score
