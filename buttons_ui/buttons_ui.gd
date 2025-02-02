extends Control

signal note_selected(color)

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
@onready var buttons = $GridContainer.get_children()

var available_notes = GameManager.available_notes
var available_colors = [Color.RED, Color.GREEN, Color.BLUE, Color.YELLOW, Color.PURPLE, Color.ORANGE, Color.CYAN]

func _ready():
	randomize_pairs()
	assign_color_to_buttons(buttons.size())
	
	for button: Button in buttons:
		button.pressed.connect(on_button_pressed.bind(button))
		

func on_button_pressed(button):
	emit_signal("note_selected", button.get_meta("note"))

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
	
func assign_color_to_buttons(number_of_buttons):
		var note_list = color_note_pairs.keys() # Get notes 
		
		buttons.shuffle()
		
		for i in range(buttons.size()):
			if i < number_of_buttons: 
				var button = buttons[i]
				var note = note_list[i]
				var color = color_note_pairs[note]["color"]
				
				button.modulate = color
				button.set_meta("note", note)

				
