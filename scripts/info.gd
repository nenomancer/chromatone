extends Control

@export var discovered_notes_display: HBoxContainer
@export var level_display: Label
@export var round_display: Label
@export var score_display: Label

func _ready() -> void:
	connect_signals()
	update_discovered_notes()

func connect_signals() -> void:
	GameManager.connect("round_changed", update_round)
	GameManager.connect("level_changed", update_level)
	GameManager.connect("score_changed", update_score)
	GameManager.connect("note_discovered", update_discovered_notes)

func update_round() -> void:
	round_display.text = var_to_str(GameManager.current_round)
	
func update_level() -> void:
	level_display.text = var_to_str(GameManager.current_level)

func update_score() -> void:
	score_display.text = var_to_str(GameManager.current_score)

func update_discovered_notes():
	for child in discovered_notes_display.get_children():
		discovered_notes_display.remove_child(child)
		child.queue_free()
		
	for note in GameManager.discovered_notes:
		add_discovered_note(note)
		
func add_discovered_note(note: String):
	var color = GameManager.color_note_pairs[note]['color']
	var discovered_note = ColorRect.new()
	discovered_note.color = color
	discovered_note.custom_minimum_size = Vector2(150, 150)
	discovered_notes_display.add_child(discovered_note)
