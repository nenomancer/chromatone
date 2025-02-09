extends Control

@export var discovered_notes_display: HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for note in GameManager.discovered_notes:
		var color = GameManager.color_note_pairs[note]['color']
		var button = Button.new()
		button.modulate = color
		button.custom_minimum_size = Vector2(120, 120)
		button.connect("_on_button_pressed", Callable(GameManager, "play_note").bind(note))
		discovered_notes_display.add_child(button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_level_pressed() -> void:
	get_tree().change_scene_to_file(GameManager.LEVELS_UI)
