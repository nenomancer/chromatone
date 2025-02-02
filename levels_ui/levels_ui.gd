extends Control

@export var level_number: int

func _ready():
	var buttons_ui = load("res://buttons_ui/buttons_ui.tscn").instantiate()
	add_child(buttons_ui)
	
	print(buttons_ui)
	buttons_ui.note_selected.connect(on_level_guess)
	
func on_level_guess(note):
	print("guessed note: ", note)
