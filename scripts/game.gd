extends Node2D

@onready var pause_node = $UI/Pause
@onready var hud = $UI/HUD
@onready var hole_container = $Holecontainer



var paused = false
var lives = 3

var game_time = 60
var hole_index_array
var total_score = 0

var rng = RandomNumberGenerator.new()

func save_score(value):
	if load_score() < value:
		var save = FileAccess.open("user://score.save", FileAccess.WRITE)
		save.store_var(value)
		print(value)

func load_score():
	if FileAccess.file_exists("user://score.save"):
		var save = FileAccess.open("user://score.save", FileAccess.READ)
		print(save)
		return save.get_var()
	return 0

func spawn_enemy():
	hole_index_array = hole_container.get_children()		
	var random_hole= hole_index_array.pick_random()
	if game_time <=30:
		var my_random_number = rng.randf_range(1,10)
		if my_random_number>= 6 && my_random_number <= 10:
			random_hole.spawn_entity(hole.entity_type.BOMB)
		if random_hole.is_bomb:
			random_hole.connect("bomb_died", on_bomb_died)
	random_hole.go_up = true	
	random_hole.can_go_down = true	
	random_hole.connect("died", on_mole_died)


func on_mole_died():
	sum_score()  
	hud.set_score_label(total_score) 

func on_bomb_died():
	lives -= 1
	hud.set_life_label(lives)

func _ready():
	Global.score = 0
	
	if !FileAccess.file_exists("user://score.save"):
		var save = FileAccess.open("user://score.save", FileAccess.WRITE)
		save.store_var(0)

func sum_score():
	var temp_score = 0
	hole_index_array = hole_container.get_children()
	for i in hole_index_array:
		if "score" in i: 
			temp_score += i.score
	total_score = temp_score

func get_total_score():
	return total_score

func _process(_delta):
	if lives <= 0:
		Global.score = total_score
		get_tree().change_scene_to_file("res://scenes/gameover.tscn")
		save_score(total_score)
		
	hud.set_score_label(total_score)
	hud.set_time_label(game_time)
	hud.set_life_label(lives)
	
	if game_time <= 30:
		pass
	if game_time <= 0:
		Global.score = total_score
		get_tree().change_scene_to_file("res://scenes/gameoverwin.tscn")
		save_score(total_score)
	
func _on_timer_timeout():
	spawn_enemy()

func _on_game_timer_timeout():
	game_time -= 1

