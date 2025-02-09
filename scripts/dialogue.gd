extends Control

@export var discovered_notes_display: HBoxContainer
const COLOR_BUTTON = preload("res://scenes/color_button.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass
	load_buttons()
	#var buttons = discovered_notes_display.get_children()
	#var note_list = GameManager.color_note_pairs.keys() # Get notes 
#
	#
	#for index in range(GameManager.discovered_notes.size()):
		##var index = GameManager.discovered_notes.
		#var note = note_list[index]
		#var color = GameManager.color_note_pairs[note]['color']
		#var button = buttons[index]
		#
		#button.modulate = color
		#button.set_meta("note", note)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_level_pressed() -> void:
	get_tree().change_scene_to_file(GameManager.LEVELS_UI)

# NOT WORKING, NOT SURE IF NEEDED, NEEDS TO BE REFACTORED FOR SURE
func load_buttons() -> void:
	print("loading buttons...")
	var buttons_ui = GameManager.BUTTONS_UI.instantiate()
	add_child(buttons_ui)
	buttons_ui.note_selected.connect(on_dialogue_press)
	#buttons_ui.disable_buttons()
	buttons_ui.enable_buttons()
	buttons_ui.enable_discovered_buttons()
	
func on_dialogue_press(note) -> void:
	print("PRESSING NOTE: ")
	print(note)
	GameManager.play_note(note)
