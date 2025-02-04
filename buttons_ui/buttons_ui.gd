extends Control

signal note_selected(color)

var number_of_colors: int = 3

var color_note_pairs = GameManager.color_note_pairs
@onready var buttons = $GridContainer.get_children()

func _ready():
	for button: Button in buttons:
		button.pressed.connect(on_button_pressed.bind(button))
		

func disable_buttons():
	for button: Button in buttons:
		button.disabled = true
		
func enable_buttons():
	for button: Button in buttons:
		button.disabled = false
		
func on_button_pressed(button):
	emit_signal("note_selected", button.get_meta("note"))

func assign_color_to_buttons(condition: Callable):
	var note_list = color_note_pairs.keys() # Get notes 
	
	buttons.shuffle()
	for i in range(buttons.size()):
		var button = buttons[i]
		var note = note_list[i]
		var color = color_note_pairs[note]["color"]
		button.text = note # For debugging
		if condition.call(note): 
			button.modulate = color
			button.set_meta("note", note)
		else: 
			button.disabled = true

func clear_color_from_buttons():
	for button in buttons:
		button.modulate = Color.WHITE

func enable_some_buttons():
	var note_list = color_note_pairs.keys() # Get notes 
	
	for button in buttons:
		var note = button.get_meta("note")
		if note not in GameManager.discovered_notes:
			button.disabled = false
		else:
			button.disabled = true
			
