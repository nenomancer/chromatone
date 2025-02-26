extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_guess_counts()
	get_parent().connect("guess_selected", _on_guess)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func generate_guess_counts():
	for child in get_children():
		remove_child(child)
		child.queue_free()
		
	for i in GameManager.discovered_notes:
		var guess = ColorRect.new()
		guess.color = Color.WEB_GRAY
		guess.custom_minimum_size = Vector2(80, 80)
		add_child(guess)
		
func _on_guess(is_correct: bool) -> void:
	var guess = get_children()[get_parent()._guess_index]
	if is_correct:
		guess.color = Color.GREEN
	else:
		guess.color = Color.RED
func clear_colors():
	for child in get_children():
		child.color = Color.WEB_GRAY
