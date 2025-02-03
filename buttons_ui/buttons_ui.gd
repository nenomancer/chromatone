extends Control

signal note_selected(color)

var number_of_colors: int = 3
# Color-note mapping
var color_note_pairs = GameManager.get_color_note_pairs()
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

func _ready():
	for button: Button in buttons:
		button.pressed.connect(on_button_pressed.bind(button))
		

func disable_buttons():
	for button: Button in buttons:
		button.disabled = true
		
func on_button_pressed(button):
	emit_signal("note_selected", button.get_meta("note"))
	disable_buttons()

func assign_color_to_buttons(condition: Callable):
	var note_list = color_note_pairs.keys() # Get notes 
	
	buttons.shuffle()
	for i in range(buttons.size()):
		var button = buttons[i]
		var note = note_list[i]
		var color = color_note_pairs[note]["color"]
		if condition.call(note, i): 
			button.modulate = color
			button.set_meta("note", note)
		else: 
			button.disabled = true
