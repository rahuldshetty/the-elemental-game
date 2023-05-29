extends Area2D

const DEFAULT_COIN_VALUE = 100

@export var coin:int = DEFAULT_COIN_VALUE

func _on_body_entered(body):
	if body.is_in_group("player") and body.has_method("update_gold"):
		body.update_gold(coin)
		body.notify("Picked up Gold({coin})".format({
			"coin": coin
		}))
		gravity_direction = body.position
		gravity = 980.0
		queue_free()
