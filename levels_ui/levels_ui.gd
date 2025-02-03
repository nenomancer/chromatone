extends Control

@export var level_number: int

var _current_round = GameManager.get_round()
var _current_level = GameManager.get_level()
#var _correct_note: String
var _correct_melody: Array
var _player_melody: Array
var i: int


var guesses: int = 0
var buttons_ui
var temp_score: int = 0
var _melody_stepsize = 1

func _ready():
	
	
	
	$ScoreLabel.text = "Current score: " + var_to_str(GameManager.get_score())
	$LevelLabel.text = "Level: " + var_to_str(_current_level)
	$RoundLabel.text = "Round: " + var_to_str(_current_round)
	
	if (_current_round == 3):
		#var available = GameManager.available_notes
		#var discovered = GameManager.discovered_notes
		#available.filter(func(element): return not discovered.has(element))
		var random_note = GameManager.get_random_note(GameManager.get_undiscovered_notes())
		GameManager.add_discovered_note(random_note)
	i = 0 # ???
	
	get_melody()
	load_buttons()
	
	
	
	await get_tree().create_timer(1).timeout
	play_melody()
		
	buttons_ui.assign_color_to_buttons(func(note, _i): return note in GameManager.get_discovered_notes())
	
func on_level_guess(note):
	GameManager.play_note(note)
	_player_melody.append(note)
	
	print(note)
	
	if note == _correct_melody[i]:
		print("CORRECT!")
		temp_score += 10
	else:
		temp_score -= 5
	i += 1
	print("TEMPSCORE: ")
	print(temp_score)
	if (i < _correct_melody.size()):
		return

	buttons_ui.disable_buttons()
	GameManager.set_score(temp_score)
	$ScoreLabel.text = "Current score: " + var_to_str(GameManager.get_score())
	
	await get_tree().create_timer(2).timeout
	# Maybe create a function for next round instead of loading this scene again
	if (_current_round < 5):
		GameManager.set_round(_current_round + 1)
	else: 
		GameManager.set_round(1)
		GameManager.set_level(_current_level + 1)
	
	get_tree().change_scene_to_file(GameManager.LEVELS_UI)
	
	
func get_melody():
	_correct_melody = GameManager.get_melody()
	print("Correct melody... ")
	print(_correct_melody)

func play_melody():
	for index in range(_correct_melody.size()):
		GameManager.play_note(_correct_melody[index])
		await get_tree().create_timer(_melody_stepsize).timeout
	
func load_buttons():
	buttons_ui = load("res://buttons_ui/buttons_ui.tscn").instantiate()
	$UI.add_child(buttons_ui)
	buttons_ui.note_selected.connect(on_level_guess)
	
