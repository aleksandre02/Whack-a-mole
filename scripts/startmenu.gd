extends Control

var game_node = preload("res://scenes/game.tscn")

@onready var high_score = $Highscorelabel

func _ready():
	var game_instance = game_node.instantiate()
	var score = game_instance.load_score()
	set_high_score_label(score)

func set_high_score_label(value):
	$Highscorelabel.text = "Highest Score:" + str(value)

func _on_exit_pressed():
	get_tree().quit()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
