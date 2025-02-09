extends Control

var _correct_note: String
var buttons_ui: Node
var _correct_guesses: int = 0
var _score: int = 0

func _ready():
	GameManager.load_buttons()
	GameManager.buttons.note_selected.connect(on_warmup_guess)
	GameManager.start_warmup()
	
#
func on_warmup_guess(note) -> void:
	#GameManager.on_warmup_guess(note)
	GameManager.play_note(note)
	var selected_button: Button = GameManager.buttons_array.filter(func(button): return button.get_meta('note') == note).front()
	var correct_button: Button = GameManager.buttons_array.filter(func(button): return button.get_meta('note') == GameManager.correct_note).front()
	
	if (GameManager.correct_note == note || GameManager.current_round - GameManager.discovered_notes.size() >= 3):
		GameManager.add_discovered_note(note)
		# Temp, to refactor: somehow mark selected button
		selected_button.modulate = Color.WHITE
	else:
		# Temp, to refactor: somehow mark both selected and correct button
		selected_button.modulate = Color.BLACK
		correct_button.modulate = Color.WHITE
		
	await get_tree().create_timer(2).timeout
	#buttons.disable_buttons()
	end_warmup()
	#end_round()

func end_warmup():
	if (GameManager.discovered_notes.size() >= 3):
		GameManager.transition_to_level()
	else: 
		if (GameManager.current_round < 5):
			GameManager.set_round(GameManager.current_round + 1)
			GameManager.start_warmup_round()
		else:
			GameManager.transition_to_level()

#func start_level_1() -> void:
	#GameManager.set_level(1)
	#GameManager.set_round(1)
	#get_tree().change_scene_to_file(GameManager.LEVELS)
#
#func end_round() -> void:
	#await get_tree().create_timer(2).timeout
	#if (GameManager.discovered_notes.size() == 3):
		#return start_level_1()
	#
	#if (GameManager.current_round < 5):
		#GameManager.set_round(GameManager.current_round + 1)
		##start_round()
	#else:
		#start_level_1()
	#
