extends Control

@export var discovered_notes_display: HBoxContainer
@export var level_display: Label
@export var round_display: Label
@export var score_display: Label

@onready var _discovered_colors: Array = discovered_notes_display.get_children()

func _ready() -> void:
	set_color_notes_shiet()
	connect_signals()
	update_discovered_notes()
	

func set_color_notes_shiet():
	var notes = GameManager.available_notes
	for i in range(_discovered_colors.size()):
		_discovered_colors[i].set_meta("note", notes[i])
		#_discovered_colors[i].modulate = GameManager.color_note_pairs[notes[i]]["color"]
func connect_signals() -> void:
	GameManager.connect("round_changed", update_round)
	GameManager.connect("level_changed", update_level)
	GameManager.connect("score_changed", update_score)
	GameManager.connect("note_discovered", add_discovered_note)

func update_round() -> void:
	round_display.text = var_to_str(GameManager.current_round)
	
func update_level() -> void:
	level_display.text = var_to_str(GameManager.current_level)

func update_score() -> void:
	score_display.text = var_to_str(GameManager.current_score)

func update_discovered_notes():
	for rect in _discovered_colors:
		var note = rect.get_meta('note')
		if note in GameManager.discovered_notes:
			var color = GameManager.color_note_pairs[note]['color'] # Ova realno treba da e funkcija
			rect.color = color
		
		
func add_discovered_note(note: String):
	var rect = _discovered_colors.filter(func(rect): return rect.get_meta("note") == note)[0]
	var color = GameManager.color_note_pairs[note]['color'] # Ova realno treba da e funkcija
	
	if rect:
		rect.color = Color(color.r, color.g, color.b, 1.0)
