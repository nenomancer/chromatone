extends HBoxContainer


@export var total_guesses: int = 3
var guess_number: int = 0
const GUESS_COUNT = preload("res://scenes/guess_count.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(total_guesses):
		var color_rect = GUESS_COUNT.instantiate()
		#color_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#color_rect.color = Color.DARK_RED
		add_child(color_rect)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	if (guess_number < total_guesses):
		guess_number += 1
		get_children()[guess_number].color = Color.YELLOW
