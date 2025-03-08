extends Node2D
class_name hole

@onready var mole = $Mole
@onready var up_marker = $"mole up"
@onready var down_marker = $"mole down"
@onready var bomb_texture = load("res://assets/Bomb1.png") 
@onready var mole_hit_texture = load("res://assets/MoleHit.png") 
@onready var mole_texture = load("res://assets/Mole.png")
#@onready var hud= load("res://hud.tscn")

signal died
signal bomb_died

enum entity_type {MOLE, BOMB}
enum texture_type {BOMB_TEXTURE, MOLE_TEXTURE, MOLE_DEAD_TEXTURE}

var position_down
var position_up
var animation_speed = 5

var score = 0
var score_increment = 10
var is_mole_dead

var go_up = false
var can_go_up = true
var can_go_down = false
var go_down = false
var is_bomb = false

var mole_goes_down_timer = 1

func _ready():
	position_down = down_marker.position
	position_up = up_marker.position

func _process(delta):
	if go_down:
		is_mole_dead = true
		mole.scale.x = lerp(0.7, 1.0, animation_speed * delta)
		mole.scale.y = lerp(0.7, 1.0, animation_speed * delta)
		mole.position = lerp(mole.position, position_down, animation_speed * delta)
		can_go_down = false
		if mole.position.y + 0.1 >= position_down.y:
			go_down = false
			can_go_up = true
		
	elif go_up:
		mole.scale.x = lerp(1.0, 0.7, animation_speed * delta)
		mole.scale.y = lerp(1.0, 0.7, animation_speed * delta)
		if is_bomb == false:
			change_hole_texture(hole.texture_type.MOLE_TEXTURE)
		mole.position = lerp(mole.position, position_up, animation_speed * delta)
		can_go_down = true
		is_mole_dead = false
		if mole.position.y - 0.1 <= position_up.y:
			can_go_up = false
			go_up = false
			await get_tree().create_timer(mole_goes_down_timer).timeout
			go_down = true
			
	if Input.is_action_just_pressed("revive"):
		go_up = true
		
func change_hole_texture(texture: texture_type):
	match texture:
		hole.texture_type.BOMB_TEXTURE:
			$Mole.texture = bomb_texture
		hole.texture_type.MOLE_TEXTURE:
			$Mole.texture = mole_texture
		hole.texture_type.MOLE_DEAD_TEXTURE:
			$Mole.texture = mole_hit_texture
	
func spawn_entity(entity: entity_type):
	match entity:
		hole.entity_type.BOMB:
			print("1")
			change_hole_texture(hole.texture_type.BOMB_TEXTURE)
			is_bomb = true	
		hole.entity_type.MOLE:
			print("2")
			change_hole_texture(hole.texture_type.MOLE_TEXTURE)
			is_bomb = false
			
func _on_button_pressed():
	if is_bomb:
		bomb_died.emit()
	else:
		change_hole_texture(hole.texture_type.MOLE_DEAD_TEXTURE)
	if is_mole_dead == false && !is_bomb:
		score += score_increment
		died.emit()
		
	if can_go_down:
		go_down = true
		can_go_down = false

