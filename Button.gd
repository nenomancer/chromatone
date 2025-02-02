extends Button

#func _ready():
	#connect("pressed", self._on_button_pressed)
	#
#func _on_button_pressed():
	#var selected_note = get_meta("note")
	#var game = get_tree().get_root().get_node("Main/GameManager")  # Get main game node
	#game.play_sound(selected_note)
	#if game.is_warmup:
		#game.check_warmup_guess(selected_note)
	#else: 
		#game.check_level_guess(selected_note)
