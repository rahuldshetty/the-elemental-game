extends Area2D

@export var dmg = 10

func _on_animated_sprite_2d_animation_finished():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(dmg)
