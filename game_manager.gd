extends Node

var available_notes = ["C", "D", "E", "F", "G", "A", "B"]
var available_colors = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.PURPLE, Color.ORANGE, Color.CYAN]

var discovered_notes = []
var current_round: int = 1
var current_level: int = 0
var current_note: String

var color_note_pairs = {}
var note_sound_map = {
	"C": preload("res://sounds/grand_piano_c.wav"),
	"D": preload("res://sounds/grand_piano_d.wav"),
	"E": preload("res://sounds/grand_piano_e.wav"),
	"F": preload("res://sounds/grand_piano_f.wav"),
	"G": preload("res://sounds/grand_piano_g.wav"),	
	"A": preload("res://sounds/grand_piano_a.wav"),
	"B": preload("res://sounds/grand_piano_b.wav")
}

var note_audio_player = AudioStreamPlayer.new()

const LEVELS_UI = "res://levels_ui/levels_ui.tscn"
const WARMUP_UI = "res://warmup_ui/warmup_ui.tscn"
const MAIN = "res://main/main.tscn"

func _ready() -> void:
	generate_audio_player()
	randomize_pairs()

func generate_audio_player():
	await get_tree().process_frame
	get_tree().root.add_child(note_audio_player)
	
func play_note(note):
	if note_audio_player:
		note_audio_player.stream = note_sound_map[note]
		note_audio_player.play()

func get_random_note() -> String:
	return available_notes.pick_random()

func add_discovered_note(note: String):
	discovered_notes.append(note)
	
func get_discovered_notes() -> Array:
	return discovered_notes

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

func randomize_pairs():
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
			"sound": note_sound_map[note]
		}
