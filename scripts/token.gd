extends Area2D


@onready var token_sfx = $TokenSfx


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.token_sfx.play()
		body.tokens += 1
		queue_free()
