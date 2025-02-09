extends Control

var _correct_note: String
var buttons_ui: Node
var _correct_guesses: int = 0
var _score: int = 0

func _ready():
	GameManager.load_buttons()
	GameManager.buttons_ui.note_selected.connect(on_warmup_guess)
	GameManager.start_warmup()
	
#
func on_warmup_guess(note) -> void:
	GameManager.on_warmup_guess(note)
	#end_round()

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
