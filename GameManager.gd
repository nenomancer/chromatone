extends Node

@onready var scene_container = $"../SceneContainer"
@onready var chromatone_ui = $"../UI/ChromatoneUI"
@onready var dialogue_ui = $"../UI/DialogueUI"

var current_level = 0
var dialogue_data = {}
# Game state
var level = 1
var score = 0
var number_of_notes = 3  # Start with 3 known notes
var melody_notes = 2  # Number of notes per melody, increases over time

# Color-note mapping
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
var available_notes = ["C", "D", "E", "F", "G", "A", "B"]
var available_colors = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.PURPLE, Color.ORANGE, Color.CYAN]
var discovered_notes = []
var current_note = null # Current playin note
var warmup_tries = 0 # Guesses in the warmup round
var is_warmup = true;
var current_round = 1

@onready var color_buttons = $"../UI/ChromatoneUI/ColorButtons".get_children() as Array[Button]
@onready var info_label = $"../UI/ChromatoneUI/InfoLabel"
@onready var audio_player = $"../Audio/AudioPlayer"


# Called when the game starts
func _ready():
	randomize_pairs()
	assign_colors_to_buttons(7)
	start_warmup_round()

func start_warmup_round():
	enable_all_buttons(false)
	is_warmup = true
	
	self.set_meta("is_warmup", true)
	assign_colors_to_buttons(7)  # Re-randomize button positions
	play_reference_note()
	
func start_level_1():
	enable_all_buttons(false)
	#self.set_meta("is_warmup", false)
	is_warmup = false
	info_label.text = "This is Level 1, Round " + var_to_str(current_round)
	assign_colors_to_buttons(7)  # Re-randomize button positions
	
func enable_all_buttons(enable = true):
	if enable:
		for button in color_buttons:
			button.disabled = false
	else: 
		for button in color_buttons:
			button.disabled = true

func play_reference_note():
	enable_all_buttons(false)
	if available_notes.size() > 0:
		current_note = available_notes[randi() % available_notes.size()]
		play_sound(current_note)
		#await audio_player.finished
		await get_tree().create_timer(2).timeout
		
	enable_all_buttons(true)	
	
func check_level_guess(selected_note):
	if (selected_note == current_note):
		score += 10
	else:
		score -= 5
		
	if (current_round < 5):
		current_round += 1
		start_level_1()
	else:
		current_round = 1
		get_tree().change_scene_to_file("res://StoryGame.tscn")
		
	

func check_warmup_guess(selected_note):
	if selected_note == current_note:
		# Correct answer
		if selected_note not in discovered_notes:
			discovered_notes.append(selected_note)
		score += 10
		print("Score: ", score)
		print ("Correct! Discovered: ", discovered_notes)
	else:
		# Incorrect answer
		warmup_tries += 1
		if warmup_tries >= 3:
			if selected_note not in discovered_notes:
				discovered_notes.append(selected_note)
			print ("Incorrect twice, saving to discovered: ", discovered_notes)
		print("Score: ", score)

	info_label.text = "Discovered: " + var_to_str(discovered_notes)
	await get_tree().create_timer(2).timeout
	if (discovered_notes.size() >= 3):
		start_level_1()
		# Go to story scene
		
		return
		
	start_warmup_round()
# Randomize pairings
func randomize_pairs():
	color_note_pairs.clear()
	
	# Shuffle notes and assign to colors
	var shuffled_colors = available_colors.duplicate()
	shuffled_colors.shuffle()
	var shuffled_notes = available_notes.duplicate()
	shuffled_notes.shuffle()
	
	for i in range(shuffled_notes.size()):
		var note = shuffled_notes[i]
		var color = shuffled_colors[i]
			
		color_note_pairs[note] = {
			"color": color,
			"sound": note_sound_map[note]
		}

# Assign colors to buttons dynamically
func assign_colors_to_buttons(number):
	#var buttons = $"../UI/ColorButtons".get_children() as Array[Button]
	var note_list = color_note_pairs.keys() # Get generated colors
	
	color_buttons.shuffle()
	
	for i in range(color_buttons.size()):
		if i < number:
			var button = color_buttons[i]
			var note = note_list[i]
			print('is note discovered: ', note, note in discovered_notes)
			button.modulate = color_note_pairs[note]["color"]
			button.set_meta("note", note)
			#button.text = note
			if is_warmup:
				button.disabled = false
			else: 
				if note in discovered_notes:
					button.disabled = false
				#else:
					#button.disabled = true
			
# Plays a sound when a button is pressed
func play_sound(note):
	
	var sound = color_note_pairs[note]["sound"]
	audio_player.stream = sound
	audio_player.play()
