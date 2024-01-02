extends Control

class_name Transition


@onready var texture_rect = $TextureRect
@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.visible = false

func anim():
	texture_rect.visible = true
	animation_player.queue("fade_out")


func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://scenes/final.tscn")
