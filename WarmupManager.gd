extends Node
signal finished

var note_color_map = {}
var remaining_attempts = 5

func _ready():
	start_warmup()
	
func start_warmup():
	print("Starting warmup!")


func play_random_note():
	return
	#var note = get_random_unmatched_note()
	#$NotePlayer.stream = load("res://sounds/" + note + ".wav")
	#$NotePlayer.play()

func on_note_selected(color):
	return
	#var correct_color = get_correct_color_for_note()
	#if color == correct_color:
		#note_color_map[note] = color
		#check_progress()
	#else:
		#remaining_attempts -= 1
		#if remaining_attempts <= 0:
			#emit_signal("finished")  # End warmup and go to dialogue

func check_progress():
	return
	#if note_color_map.size() >= 3:
		#emit_signal("finished")  # Move to first dialogue
	#else:
		#play_random_note()
