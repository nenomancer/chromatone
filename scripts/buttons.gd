extends Control

signal note_selected(button)

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
		
func enable_warmup_buttons():
	for button in _buttons:
		var note = button.get_meta('note')
		
		# Enable buttons if they're warmup notes and not yet discovered
		if (GameManager.warmup_notes.has(note) and not GameManager.discovered_notes.has(note)):
			button.disabled = false
		
func on_button_pressed(_button):
	#emit_signal("note_selected", _button.get_meta("note"))
	emit_signal("note_selected", _button)

# Use this for the in-game discovered notes as well, so they're not shuffled
func assign_color_to_buttons(condition: Callable, shuffle: bool = true):
	clear_color_from_buttons()
	var note_list = GameManager.color_note_pairs.keys()
	if shuffle:
		_buttons.shuffle()
		
	for i in range(_buttons.size()):
		var _button = _buttons[i]
		var note = note_list[i]
		
		if not shuffle:
			note = GameManager.available_notes[i]
			
		var color = GameManager.color_note_pairs[note]["color"]
		#_button.text = note # For debugging
		_button.disabled = true
		_button.set_meta("note", note)
		
		if condition.call(note): 
			_button.modulate = color

func clear_color_from_buttons():
	# Might need to refactor this to take arguments,
	# mainly for warmup round, to accent 
	# guess and correct button
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
		
func get_button_by_note(note: String):
	return _buttons.filter(func(button): return button.get_meta("note") == note)[0]
