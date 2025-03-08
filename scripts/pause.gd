extends Control


var paused = false


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/startmenu.tscn")
	pause_menu()

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	pause_menu()

func _on_continue_pressed():
	pause_menu()

func _on_exit_pressed():
	get_tree().quit()
	
func pause_menu():
	if paused:
		self.hide()
		Engine.time_scale = 1
	else:
		self.show()
		Engine.time_scale = 0
	paused = !paused

func _process(delta):	
	if Input.is_action_just_pressed("escape_menu"):
		pause_menu()
	
