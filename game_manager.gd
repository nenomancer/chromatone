extends Node

signal round_changed
signal level_changed
signal score_changed
signal note_discovered(note: String)

var available_notes: Array = ["C", "D", "E", "F", "G", "A", "B"]
var available_colors: Array = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.PURPLE, Color.ORANGE, Color.CYAN]

var warmup_tier: int = 0
var warmup_notes: Array

var current_round: int = 1
var current_level: int = 1
var current_score: int = 0
var current_note: String

var discovered_notes: Array = []
var color_note_pairs: Dictionary = {}
var _note_sound_map: Dictionary = {
	"C": preload("res://sounds/grand_piano_c.wav"),
	"D": preload("res://sounds/grand_piano_d.wav"),
	"E": preload("res://sounds/grand_piano_e.wav"),
	"F": preload("res://sounds/grand_piano_f.wav"),
	"G": preload("res://sounds/grand_piano_g.wav"),	
	"A": preload("res://sounds/grand_piano_a.wav"),
	"B": preload("res://sounds/grand_piano_b.wav")
}
var _call_notes: Dictionary = {
	"C": preload("res://sounds/call/call_c.wav"),
	"D": preload("res://sounds/call/call_d.wav"),
	"E": preload("res://sounds/call/call_e.wav"),
	"F": preload("res://sounds/call/call_f.wav"),
	"G": preload("res://sounds/call/call_g.wav"),	
	"A": preload("res://sounds/call/call_a.wav"),
	"B": preload("res://sounds/call/call_b.wav")
}
var _answer_notes: Dictionary = {
	"C": preload("res://sounds/answer/answer_c.wav"),
	"D": preload("res://sounds/answer/answer_d.wav"),
	"E": preload("res://sounds/answer/answer_e.wav"),
	"F": preload("res://sounds/answer/answer_f.wav"),
	"G": preload("res://sounds/answer/answer_g.wav"),	
	"A": preload("res://sounds/answer/answer_a.wav"),
	"B": preload("res://sounds/answer/answer_b.wav")
}

var _note_audio_player: AudioStreamPlayer = AudioStreamPlayer.new()

const LEVELS: String = "res://scenes/levels.tscn"
const WARMUP: String = "res://scenes/warmup.tscn"
const MAIN: String = "res://scenes/main.tscn"
const DIALOGUE: String = "res://scenes/after_level.tscn"
const BUTTONS = preload("res://scenes/buttons.tscn")
const INFO = preload("res://scenes/info.tscn")
const GUESS_COUNTER = preload("res://scenes/guess_counter.tscn")

enum SOUNDS { CALL, ANSWER }

func _ready() -> void:
	generate_audio_player()
	randomize_pairs()
	#assign_warmup_notes()
	warmup_notes.append(get_random_note(available_notes))

func generate_audio_player() -> void:
	await get_tree().process_frame
	#_note_audio_player.volume_db = -14.0 # Temporary
	#_note_audio_player.pitch_scale = 7 # Add in future
	
	
	get_tree().root.add_child(_note_audio_player)
	
func play_note(note: String, type: SOUNDS) -> void:
	if _note_audio_player:
		if (type == SOUNDS.CALL):
			_note_audio_player.stream = _note_sound_map[note]
		if (type == SOUNDS.ANSWER):
			_note_audio_player.stream = _note_sound_map[note] # Change answer sound
			
		_note_audio_player.play()

func assign_warmup_notes():
	var other_notes = available_notes.filter(func(note): return note not in warmup_notes)
	for i in range(mini(warmup_notes.size() + 1, 2)):
		var note = get_random_note(other_notes)
		warmup_notes.append(note)
		
func get_random_note(_note_array) -> String:
	return _note_array.pick_random()

func add_discovered_note(note: String):
	discovered_notes.append(note)
	emit_signal("note_discovered", note)
	
func get_undiscovered_notes() -> Array:
	return available_notes.filter(func(element): return not discovered_notes.has(element))

func set_round(new_round: int):
	current_round = new_round
	emit_signal("round_changed")

func set_level(new_level: int):
	current_level = new_level
	emit_signal("level_changed")

func update_score(amount: int):
	current_score += amount
	emit_signal("score_changed")

# This happens once per game (should be saved along)
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

func show_notification_popup(button: Button):
	var note = button.get_meta("note")
	var color = button.modulate
	var position = button.position
	var label = Label.new()
	
	label.text = note + " Discovered!"
	label.z_index = 1
	label.set("theme_override_colors/font_color", color)
	label.set("theme_override_font_sizes/font_size", 32)
	
	#label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2(0, -200)
	button.get_parent().get_parent().add_child(label)
	
	var tween = get_tree().create_tween()
	tween.tween_property(label, "position", Vector2(0, -220), 1)
	tween.tween_property(label, "modulate", Color(color.r, color.g, color.b, 0), 1)
	
	await tween.finished
	label.queue_free()
