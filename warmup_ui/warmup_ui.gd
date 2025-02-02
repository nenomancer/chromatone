extends Control

@export var current_round: int = 1
@export var current_note: String

func _ready():
	var buttons_ui = load("res://buttons_ui/buttons_ui.tscn").instantiate()
	add_child(buttons_ui)
	
	buttons_ui.note_selected.connect(on_warmup_guess)
	
func on_warmup_guess(note):
	print("warmup note is: ", note)
