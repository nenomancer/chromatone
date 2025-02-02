extends Node

var available_notes = ["C", "D", "E", "F", "G", "A", "B"]
var discovered_notes = []
var current_round: int = 1
var current_level: int = 0


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

