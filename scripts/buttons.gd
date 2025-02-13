extends Control

signal note_selected(color)

@onready var _buttons = $GridContainer.get_children()

func _ready():
	for _button: Button in _buttons:
		_button.pressed.connect(on_button_pressed.bind(_button))

func disable_buttons():
	for _button: Button in _buttons:
		_button.disabled = true
		
func enable_buttons():
	for _button: Button in _buttons:
		_button.disabled = false
		
func on_button_pressed(_button):
	emit_signal("note_selected", _button.get_meta("note"))

func assign_color_to_buttons(condition: Callable, shuffle: bool = true):
	var note_list = GameManager.color_note_pairs.keys() # Get notes 
	_buttons.shuffle()
		
	for i in range(_buttons.size()):
		var _button = _buttons[i]
		var note = note_list[i]
		if not shuffle:
			note = GameManager.available_notes[i]
			
		var color = GameManager.color_note_pairs[note]["color"]
		_button.text = note # For debugging
		if condition.call(note): 
			_button.modulate = color
			_button.set_meta("note", note)
		else: 
			_button.disabled = true

func clear_color_from_buttons():
	for _button in _buttons:
		_button.modulate = Color.WHITE

func enable_undiscovered_buttons():
	for _button in _buttons:
		var note = _button.get_meta("note")
		if note not in GameManager.discovered_notes:
			_button.disabled = false
		else:
			_button.disabled = true
			
func enable_discovered_buttons():
	for _button in _buttons:
		var note = _button.get_meta("note")
		if note in GameManager.discovered_notes:
			_button.disabled = false
		else:
			_button.disabled = true
