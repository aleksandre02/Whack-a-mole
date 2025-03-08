extends Control



var game_node = preload("res://scenes/game.tscn")

func _ready():
	var game_instance = game_node.instantiate()
	var high_score = game_instance.load_score()
	set_high_score_label(high_score)
	set_score_label(Global.score)

func set_score_label(value):
	$Score.text = "Score: " + str(value)
	

func set_high_score_label(value):
	$Highscorelabel.text = "Highest Score: " + str(value)

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_exit_pressed():
	get_tree().change_scene_to_file("res://scenes/startmenu.tscn")
