extends Area2D


@export var transition : Transition
@export var sfx : AudioStreamPlayer2D


func _on_body_entered(body):
	if body.is_in_group("Player"):
		sfx.play()
		get_tree().call_group("audio", "stop")
		transition.anim()
