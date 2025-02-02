extends Control
signal note_selected(color)

func _ready():
	$"Buttons".note_selected.connect(printshit)
	
	for button in $"Buttons".get_children():
		button.pressed.connect(func(): emit_signal("note_selected", button.modulate))
		
func on_button_pressed():
	print("EYOOOO")
	return

func printshit():
	print("EAPASK")
	
