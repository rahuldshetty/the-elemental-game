extends Area2D

@export var xp:int = 500

func _on_body_entered(body):
	if body.is_in_group("player") and body.has_method("update_xp"):
		body.update_xp(xp)
		body.notify("Picked up XP Boost({xp})".format({
			"xp": xp
		}))
		queue_free()
